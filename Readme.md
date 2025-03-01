
THIS README.MD IS TO EXPLAIN THE LIST OF COMMANDS AND ITS ORDER.
GIT COMMITTING THE CHANGES TO THE REPO: PUBLIC-PRIVATE CONSORTIUM >>>>>>> 

1) after doing the changes use this command : git add . 
            for commiting induvidual file: git add file.py

2) Describe the nature of the change: git commit -m "Describe your changes here"
            to add the nature of the change 


3) to push the changes to the branch: git push origin master

4) to check the status of the repo: git status
            to check the status of the repo


                                Docker Commands 
anand@Anand:BC
1) go to the app dir in the docekr lib
anand@Anand:BC  cd docker/app/
2) to run the docker container 
             docker compose up -d 
3) to create the docker container from scratch without using the app cache
             docker compose build --no-cache
4) to use account with eth for testing 
             geth --dev
