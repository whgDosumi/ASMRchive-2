# Versioning

Versioning in ASMRchive is handled automatically by a github actions workflow. This standardizes the process, prevents mistakes, and simplifies the development workflow.   

When pushing changes to the 'master' branch, the following will happen:

1. A workflow will trigger which will check the commit messages.
2. The version will be updated based on the commit message.
3. The changelog will be updated with the changes made.
4. The version.txt and CHANGELOG.md files will be commited directly to the master branch.

## How to use
- The logic expects you to use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).  
- When merging your branch, we tend to stick to squash merging. This keeps the commit history much cleaner.  
- The logic scans your ENTIRE commit message, not just the title. So, if you don't edit your description (the big list of all of your commits) you could see unexpected behavior.  
- If your commit contains the keyword "[skip-ci]" it will skip the workflow and will not update the changelog or version. This is appropriate for simple changes like doc updates. 

### Notes:
The default change is considered a patch, and will tick the final number of the version. If conventional commits are not followed, patch will be assumed. (please just follow the standard)  

Currently feat: is the only tag that will be considered a minor update (change the second number). 

The first number, major, is only updated if a breaking change happens. I'll probably manually bump to version 1 once the project is kicked off. Breaking changes can be defined using the conventional commits standard. 

The script that updates the version is really simple, feel free to check ./bump_version.sh if you are curious how it works. 