Launch Multiple Cursor Composer AI Agents to Work in Parallel


https://egghead.io/launch-multiple-cursor-composer-ai-agents-to-work-in-parallel~y1q56

Launch Multiple Cursor Composer AI Agents to Work in Parallel
John Lindquist
Instructor
John Lindquist

3
cursor
Cursor (ide)
AI coding assistants (like Cursor's Composer) are powerful, but running a single instance can become a bottleneck, especially for larger tasks or when experimenting with different approaches. This lesson shows you how to break free from that limitation by leveraging Git worktrees to enable parallel AI development.

The Problem:

Single Composer instances can be slow for complex tasks.
Multiple agents modifying the same files simultaneously lead to conflicts.
Traditional branching can be cumbersome for rapid experimentation.
The Solution: Git Worktrees

Git worktrees allow you to create multiple, independent working directories linked to the same Git repository. Each worktree can be associated with a different branch, providing isolated environments for development.

Workflow:

Create Worktrees: Use git worktree add -b <branch-name> ../<project-name>-<branch-name> to create a new worktree and associated branch. The -b flag creates the branch. The path (../<project-name>-<branch-name>) places the worktree in a sibling directory (cleaner organization). Repeat for each variation you want to explore.
Launch Multiple Cursor Instances: Open Cursor in each worktree directory (e.g., cursor ../my-project-variant1). Each instance is now isolated and can work on its assigned branch.
Assign Tasks to Composer: Within each Cursor instance, use Composer (Chat or Agent mode) to work on specific tasks or implement different approaches to the same problem. Use @ to provide context (files, directories, docs).
Monitor and Iterate: Check in on each Composer instance's progress. Because they're in separate worktrees, there are no conflicts.
Merge the Best Solution: Once a branch has a successful solution, merge it back into your main branch using git merge <branch-name>.
Clean Up: Remove the worktrees with git worktree remove ../<project-name>-<branch-name>.
ZSH Functions (Optional but Powerful):

The lesson introduces two ZSH functions (provided as code snippets) to automate this process:

wtree(): Takes branch names as arguments, creates corresponding worktrees, installs dependencies (with -p flag for PNPM), and optionally launches Cursor in each. This streamlines setup.
wtmerge(): Takes a single branch name as an argument, merges that branch into main, and then cleans up all worktrees created by wtree(). This simplifies merging and cleanup.
Benefits:

Parallel Development: Run multiple Composer instances simultaneously, drastically speeding up development.
Conflict-Free Experimentation: Isolate different approaches in separate branches/worktrees, eliminating merge conflicts.
Rapid Iteration: Quickly create, test, and merge (or discard) variations of your code.
Clean Workspace: Worktrees keep your main project directory uncluttered.
This lesson empowers you to unlock the full potential of AI coding assistants by running them in parallel, fostering faster experimentation and more efficient development. You'll learn a practical technique that significantly boosts your productivity when working with AI-generated code.

# wtree: Create a new worktree for each given branch.
# Usage: wtree [ -p|--pnpm ] branch1 branch2 ...
#
# This function does the following:
#   1. Parses command-line arguments; if -p/--pnpm is provided, it will later run "pnpm install".
#   2. Determines the current branch and repository root.
#   3. Uses a fixed parent directory (~/dev) to house all worktree directories.
#   4. For each branch passed:
#        - If the branch does not exist, it is created from the current branch.
#        - It checks that a worktree for that branch does not already exist.
#        - It then creates a worktree in ~/dev using a naming convention: <repoName>-<branch>.
#        - If the install-deps flag is true, it runs "pnpm install" inside the new worktree.
#        - Finally, it either opens the new worktree via the custom "cursor" command (if defined)
#          or prints its path.
wtree() {
  # Flag to determine whether to run "pnpm install"
  local install_deps=false
  local branches=()

  # Parse command-line arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--pnpm)
        install_deps=true
        shift
        ;;
      *)
        branches+=("$1")
        shift
        ;;
    esac
  done

  # Ensure at least one branch name is provided.
  if [[ ${#branches[@]} -eq 0 ]]; then
    echo "Usage: wtree [ -p|--pnpm ] branch1 branch2 ..."
    return 1
  fi

  # Determine the current branch; exit if not in a git repository.
  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD) || {
    echo "Error: Not a git repository."
    return 1
  }

  # Determine repository root and name.
  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel) || {
    echo "Error: Cannot determine repository root."
    return 1
  }
  repo_name=$(basename "$repo_root")

  # Set fixed parent directory for worktrees.
  local worktree_parent="$HOME/dev"
  # Ensure the worktree parent directory exists.
  if [[ ! -d "$worktree_parent" ]]; then
    if ! mkdir -p "$worktree_parent"; then
      echo "Error: Failed to create worktree parent directory: $worktree_parent"
      return 1
    fi
  fi

  # Loop over each branch provided as argument.
  for branch in "${branches[@]}"; do
    # Define the target path using a naming convention: <repoName>-<branch>
    local target_path="$worktree_parent/${repo_name}-${branch}"
    
    echo "Processing branch: ${branch}"

    # Check if a worktree already exists at the target path.
    if git worktree list | grep -q "^${target_path}[[:space:]]"; then
      echo "Error: Worktree already exists at ${target_path}. Skipping branch '${branch}'."
      continue
    fi

    # If the branch does not exist, create it from the current branch.
    if ! git show-ref --verify --quiet "refs/heads/${branch}"; then
      echo "Branch '${branch}' does not exist. Creating it from '${current_branch}'..."
      if ! git branch "${branch}"; then
        echo "Error: Failed to create branch '${branch}'. Skipping."
        continue
      fi
    fi

    # Create the new worktree for the branch.
    echo "Creating worktree for branch '${branch}' at ${target_path}..."
    if ! git worktree add "$target_path" "${branch}"; then
      echo "Error: Failed to create worktree for branch '${branch}'. Skipping."
      continue
    fi

    # If the install flag is set, run "pnpm install" in the new worktree.
    if $install_deps; then
      echo "Installing dependencies in worktree for branch '${branch}'..."
      if ! ( cd "$target_path" && pnpm install ); then
        echo "Warning: Failed to install dependencies in '${target_path}'."
      fi
    fi

    # Optionally, open the worktree directory via a custom "cursor" command if available.
    if type cursor >/dev/null 2>&1; then
      cursor "$target_path"
    else
      echo "Worktree created at: ${target_path}"
    fi

    echo "Worktree for branch '${branch}' created successfully."
    echo "-----------------------------------------------------"
  done
}


# wtmerge: Merge changes from a specified worktree branch into main,
# then clean up all worktrees and delete their branches.
#
# Usage: wtmerge <branch-to-keep>
#
# This function does the following:
#   1. Verifies that the branch to merge (branch-to-keep) exists as an active worktree.
#   2. Checks for uncommitted changes in that worktree:
#        - If changes exist, it attempts to stage and commit them.
#        - It gracefully handles the situation where there are no changes.
#   3. Switches the current (main) worktree to the "main" branch.
#   4. Merges the specified branch into main, with proper error checking.
#   5. Uses "git worktree list" to retrieve all active worktrees (under ~/dev
#      and matching the naming pattern) and removes them.
#   6. Deletes each branch that was created for a worktree (skipping "main").
wtmerge() {
  # Ensure exactly one argument is passed: the branch to merge.
  if [ $# -ne 1 ]; then
    echo "Usage: wtmerge <branch-to-keep>"
    return 1
  fi

  local branch_to_keep="$1"

  # Determine the repository root and its name.
  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel) || {
    echo "Error: Not a git repository."
    return 1
  }
  repo_name=$(basename "$repo_root")

  # Fixed parent directory where worktrees are located.
  local worktree_parent="$HOME/dev"

  # Retrieve all active worktrees (from git worktree list) that match our naming convention.
  local worktrees=()
  while IFS= read -r line; do
    # Extract the worktree path (first field)
    local wt_path
    wt_path=$(echo "$line" | awk '{print $1}')
    # Only consider worktrees under our fixed parent directory that match "<repo_name>-*"
    if [[ "$wt_path" == "$worktree_parent/${repo_name}-"* ]]; then
      worktrees+=("$wt_path")
    fi
  done < <(git worktree list)

  # Check that the target branch worktree exists.
  local target_worktree=""
  for wt in "${worktrees[@]}"; do
    if [[ "$wt" == "$worktree_parent/${repo_name}-${branch_to_keep}" ]]; then
      target_worktree="$wt"
      break
    fi
  done

  if [[ -z "$target_worktree" ]]; then
    echo "Error: No active worktree found for branch '${branch_to_keep}' under ${worktree_parent}."
    return 1
  fi

  # Step 1: In the target worktree, check for uncommitted changes.
  echo "Checking for uncommitted changes in worktree for branch '${branch_to_keep}'..."
  if ! ( cd "$target_worktree" && git diff --quiet && git diff --cached --quiet ); then
    echo "Changes detected in branch '${branch_to_keep}'. Attempting auto-commit..."
    if ! ( cd "$target_worktree" &&
            git add . &&
            git commit -m "chore: auto-commit changes in '${branch_to_keep}' before merge" ); then
      echo "Error: Auto-commit failed in branch '${branch_to_keep}'. Aborting merge."
      return 1
    else
      echo "Auto-commit successful in branch '${branch_to_keep}'."
    fi
  else
    echo "No uncommitted changes found in branch '${branch_to_keep}'."
  fi

  # Step 2: Switch to the main worktree (assumed to be the current directory) and check out main.
  echo "Switching to 'main' branch in the main worktree..."
  if ! git checkout main; then
    echo "Error: Failed to switch to 'main' branch."
    return 1
  fi

  # Step 3: Merge the target branch into main.
  echo "Merging branch '${branch_to_keep}' into 'main'..."
  if ! git merge "${branch_to_keep}" -m "feat: merge changes from '${branch_to_keep}'"; then
    echo "Error: Merge failed. Please resolve conflicts and try again."
    return 1
  fi

  # Step 4: Remove all worktrees that were created via wtree().
  echo "Cleaning up worktrees and deleting temporary branches..."
  for wt in "${worktrees[@]}"; do
    # Extract branch name from worktree path.
    local wt_branch
    wt_branch=$(basename "$wt")
    wt_branch=${wt_branch#${repo_name}-}  # Remove the repo name prefix

    echo "Processing worktree for branch '${wt_branch}' at ${wt}..."
    # Remove the worktree using --force to ensure removal.
    if git worktree remove "$wt" --force; then
      echo "Worktree at ${wt} removed."
    else
      echo "Warning: Failed to remove worktree at ${wt}."
    fi

    # Do not delete the 'main' branch.
    if [[ "$wt_branch" != "main" ]]; then
      if git branch -D "$wt_branch"; then
        echo "Branch '${wt_branch}' deleted."
      else
        echo "Warning: Failed to delete branch '${wt_branch}'."
      fi
    fi
  done

  echo "Merge complete: Branch '${branch_to_keep}' merged into 'main', and all worktrees cleaned up."
}
Share with a coworker

Transcript
[00:00] Git-worktree, which you already have installed if you have git, allows you to add a branch with "-b". And we'll call this branch full-path, just follow your team's naming schemes for branches. And then a directory where you want this work tree to be added. So we'll go up a directory, then slash, then the name of our current project, which is fileForge, and then dash full-path. So once I hit enter here, it's created this new branch, checked everything out, and if I run cursor and go up a directory and then over up to fileForge dash full-path and hit enter, You'll see I have a brand new instance of cursor running, and if I make a change to like the readme or some minor change, let's say contributing, sounds great, we can just undo this later.

[00:45] But when I commit the changes here we'll add this and generate a message and commit. Oh I forgot this will run my pre-commit hooks, so I do need to at least install the required packages so that the pre-commit hooks can run and run the tests. And that's just happening behind the scenes right now. So all the tests pass behind the scenes and the commit was successful. We can hop back over to our main branch.

[01:08] We can say git merge, and then merge in the full path branch. Let me show you the readme so that when you see the before and after. So I'll hit enter. There's no contributing. And after I get this contributing section in.

[01:22] And you'll see with our git status, we have one commit we need to push to our remote. So at this point we can git worktree remove, and then go up the directory, and then pass in our file forge full path, hit enter. And that cleaned up. If I try and swap back over to this project you'll see all the files are deleted and there's nothing in here because all the work here is done. So to start multiple composer sessions working on different branches I'll show you this function in zshrc.

[01:52] I called it wtree and this will be shared below. Once you invoke wtree you can pass in as many branches as you want to create. If you pass in the P flag it'll automatically use PMPM to install dependencies. You'd have to configure this based on the projects you're working on. And then once everything is set up it's going to fire off cursor to open each project.

[02:13] So let's say in my scenario I want to work on that full path feature and I want to work on a few variations of it. So I'll just say A, B, and C, and then with dash P it'll install all the packages. So once I hit enter here it's going to create all those work trees, install all the packages, launch cursor for each of them, and then I have these three separate branches with three separate workspaces where I can experiment with Composer working on the same thing in three different ways. And I'll just create a new space for each of these so if I'll grab A I can drop it here, B drop it here, C drop it over here, So I can essentially check in on them as they're working through the issues. Then open Composer, give it a task.

[02:56] I'll just give it my source, my test directory, then tell it to please implement a feature where if a user passes in the full path to a file it can also be included within the final digest that's output. Hit enter and then you can go over and either work on the same task or work on a separate task, then get multiple composers all running at the same time. And you can come in and check on them, see if you like the results. If you're working with different web servers, you'd want to give each one a different port so you could check that on different browsers. And I've set it up in my workflow where I also have this merge function.

[03:32] So I'm going to W merge or WT merge and this is going to allow me to pick the branch that I think won rather than manually merging in each one. It's going to pick the one that I think was best. We'll say that it was full path A. Hit enter and that's going to bring in all the changes from full path A. Looks like there is some undefined things we need to fix up first.

[03:54] So let's go into fixtures, dir, accept all, open our problems, we'll attempt to fix with AI. Hit accept here, then go back and try and run this again. So we'll merge in fullPathA, so it's bringing in all those changes, and then because it's committing it's running all my tests I always run my tests on commit. Then it looks like the feature that we added wasn't fully fixed. I don't know why I expected Composer to be able to one-shot this, but I'll start a new Composer, I'll switch to agent mode, paste in the issues, I'll say run pnpm test, attempt to fix all of the failing tests, Hit enter.

[04:30] All right for the sake of the video I was trying to have Composer fix this. I'm just going to unstage and revert all my changes. This was a much more complicated task than a one sentence description. I could have made a plan and all the standard practices for working on more complicated tasks. For now, I'm just going to remove this part of the readme we made before.

[04:51] Then once I go back over, I'll run my WT merge full path again. So now all the tests pass and you can see that it's committing our changes, bringing everything in, and it's deleting all the branches, deleting all the work trees. So if we check our other spaces here you'll see that this path A is gone, path B is gone, path C is gone. We could have had all of these working on different tasks and this WTMerge function is for picking out the specific one, the one that you like the best. And you can see we now have the changes where it removed what we added to the readme.

[05:25] So I'll share these functions below. You could definitely do these manually or ask the AI to do this sort of stuff for you, but to be very aware once you use these I did hard code the parent directory for all of my projects. So mine will put it in the home dev directory. You could ask AI to add a flagged configure where you want that to be or just hardcode yours. And I do have WT merge only support keeping one branch and then deleting the rest.

[05:52] If you want a different behavior please ask an AI to work on that for you. It's fairly simple logic for it to handle. But you could also just go through all the manual steps of get work tree add, get work tree remove, get merge branch in, and all the manual steps that that would take as well.