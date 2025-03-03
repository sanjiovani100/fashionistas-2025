
Generate Custom .cursorrules for Your Project Based on Community Examples

https://egghead.io/generate-custom-cursorrules-for-your-project-based-on-community-examples~eimq2


Generate Custom .cursorrules for Your Project Based on Community Examples
John Lindquist
Instructor
John Lindquist

12
cursor
Cursor (ide)
Many people share .cursorrules files, but trying to craft your own from scratch is a huge pain. Instead, this lesson shows you how to grab ALL community-created .cursorrules files to build a custom rule set for your projects. We'll use Gitingest and Google AI Studio to gather these examples and generate an awesome starting point customized to your specific project.

Share with a coworker

Transcript
[00:00] PatrickJS has collected a large set of cursor rules from around the community and if we change hub to ingest we can actually download all of them. And once we open AI studio with Gemini Flash experimental we can add a file. So in my downloads folder I'll add this cursor rules file and click open. Now I'm also going to swap over to what's currently egghead.io. I'll change hub to ingest and for this one I'm only going to include the TypeScript and the react files and the package.json files so it knows which libraries I'm using.

[00:35] Otherwise 700, 000 tokens is kind of a bit. We'll click ingest, swap back over to AI studio, add another file, upload file, grab the downloaded version which is 2.6 megs of text And now we're pushing this all the way to 950, 000 tokens. And I'll also turn on grounding. So web search is enabled. And I can say, based on all of the cursor rules examples that I uploaded, please generate a new cursor rules file that will help AI agents generate code consistent with the code in our egghead repo.

[01:05] We'll paste that in, let it run, this will probably take a while. Well it looks like something silently failed here so let's try again with like files under 4 kilobytes and that should give us enough to work with. So we'll download this one, we'll remove this, remove this, let's go ahead and upload a revised version. I'm assuming 900, 000 tokens was just too much. It did fail after about five minutes.

[01:31] And we'll try the same prompt based on the cursor rules examples I've uploaded. Please create a cursor rules file that is consistent with the egghead repo code base that I've uploaded to help guide AI agents to write code consistent with the repository. Try it again. Now after 84 seconds the result is in a JSON format which is a bit unexpected. I didn't browse all of the examples but I did see a handful that were in JSON.

[01:57] And it's capturing some basic formatting, naming conventions, avoid enums is interesting, type all the things I like. And so try this on your own repo, see what it comes up with. I do like this project specific section where it explicitly calls out the data fetching state management etc. And I do think one thing I would add here which I don't see is when you run into library specific code, anytime your AI agent fails at a task, AI agents will often fail when dealing with library specific code. So once it fails and you fix it, I would copy that sort of concept over into the cursor rules file to prevent those in the future.

[02:33] Otherwise this is an awesome starting point and the only way to really verify it is to copy and paste it in your project, see how your AI agent feels, and tweak it as you move along.