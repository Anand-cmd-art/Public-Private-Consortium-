
## THIS README.MD IS TO EXPLAIN THE LIST OF COMMANDS AND ITS ORDER. GIT COMMITTING THE CHANGES TO THE REPO: PUBLIC-PRIVATE CONSORTIUM 

  **After making changes, add them to staging:**
   ```bash
   git add .
    
    
Describe the nature of the change: 
    
    git commit -m "Describe your changes here"
        


3) to push the changes to the branch: 
    
    git push origin master

4)  to check the status of the repo: 
    
    
    git status

5)  to review the changes and conflicts that are arisng between the local and remote: 
        
     
    git rebase


Docker Commands 

anand@Anand:BC
1)  go to the app dir in the docekr lib
    
    
    anand@Anand:BC  
    cd docker/app

2)  to run the docker container 
                 
    docker compose up -d 

3)  to create the docker container from scratch without using the app cache
    
    docker compose build --no-cache

4)  to use account with eth for testing 
    
    geth --dev
