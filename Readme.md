
## THIS README.MD IS TO EXPLAIN THE LIST OF COMMANDS AND ITS ORDER. GIT COMMITTING THE CHANGES TO THE REPO: PUBLIC-PRIVATE CONSORTIUM 

 1) after doing the changes use this command :
 
 ```bash 
 git add .
    

2)  Describe the nature of the change:  
    
    ```bash
    git commit -m "Describe your changes here"
        


3) #to push the changes to the branch: 
    ```bash
    git push origin master

4)  to check the status of the repo: 
    
    ```bash
    git status

5)  to review the changes and conflicts that are arisng between the local and remote: 
        
     ```bash
    git rebase


# Docker Commands 

anand@Anand:BC
1)  go to the app dir in the docekr lib
    
    ```bash
    anand@Anand:BC  
    cd docker/app

2)  to run the docker container 
             
    ```bash         
    docker compose up -d 
3)  to create the docker container from scratch without using the app cache
    
    ```bash
    docker compose build --no-cache
4)  to use account with eth for testing 
    
    ```bash
    geth --dev
