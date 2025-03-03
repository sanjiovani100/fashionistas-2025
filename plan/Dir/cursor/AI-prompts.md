

https://egghead.io/create-ai-prompts-based-on-a-directory-of-files~w1m9u

Create AI Prompts Based on a Directory of Files
John Lindquist
Instructor
John Lindquist

3
next
Next.js
cursor
Cursor (ide)
Using Cursor Chat, you can easily reference an entire directory of files and ask it to generate anything based on those files. This opens up the possibility of using your current code as a reference guide to create new code that follows existing patterns. With this approach, the result can be a polished prompt you can use with any AI to generate consistent and reliable output.

Focus less on crafting the perfect prompt upfront - what matters most is testing and iterating based on the AI's responses. The more results you see from the prompt, the more you can reinforce the good results and prune out the bad results until your prompt is polished enough that you can rely on the prompt to give you consistent quality results.

Share with a coworker

Transcript
[00:00] Chat with command L, then reference the pages directory with at flash pages and we'll select source pages. Then I'll dictate based on our current pages generate a strict guide to follow when creating a new page, provide specific examples, and target this for someone who has never created a page before. We'll paste that in, hit enter, then we'll read all of our current pages that it can access and it will create this guide for us. One thing to be aware of is that this is generating markdown and markdown formatting with code blocks will often fail in pretty much every AI based tool simply because they're trying to render a markdown inside of markdown. So the easiest way to capture all of this is to scroll to the bottom and click copy message which copies the entire message.

[00:45] Then I'm going to create a file. I'll go to the root, say new file, and create a folder called composer and a file named pages-prompt.markdown and paste this all in here. Now at this point you'd be tempted to review this and fix things. My suggestion would be is to use this and then iterate and then fix things. So for example open a new composer with option shift I and we'll say use the pages prompt to create a new content heavy page about John Lindquist.

[01:21] And I'm gonna let it search the internet for information about me. We'll hit submit. Then it talks about following our guidelines from the pages prompt. We'll just go ahead and accept all and I'll review this in the editor. You can review it in here, I find it a bit difficult in the smaller size and I'll close this out.

[01:38] I'm also going to quickly install an MDX extension and install that just so we can get some highlighting here. And then we review the output, find the things we like, find the things we dislike, and then iterate on the pages prompt.