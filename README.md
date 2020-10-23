# copy_folder_to_another_repo_action
This GitHub Action copies a folder from the current repository to a location in another repository

# Example Workflow
    name: Push File

    on: push

    jobs:
      copy-file:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Pushes test folder
          uses: miw-codelabs/copy_folder_to_another_repo_action@main
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            source_repo: 'tester/source-repo'
            source_folder: 'test_files'
            destination_repo: 'tester/destination-repo'
            destination_folder: 'test-dir'
            source_branch: main
            destination_branch: main
            user_email: 'test@test.com'
            user_name: 'tester'
            commit_msg: 'Copied folder from source repo'
            auth_token: API_TOKEN_GITHUB

# Variables
* source_repo: The repo to be copied from.
* source_folder: The folder to be copied.
* destination_repo: The repository to place the folder in.
* destination_folder: [optional] The folder in the destination repository to place the file in, if not the root directory.
* user_email: The GitHub user email associated with the API token secret.
* user_name: The GitHub username associated with the API token secret.
* destination_branch: [optional] The branch of the source repo to update, if not master.
* commit_msg: [optional] The commit message to use.

# Behavior Notes
- The action will remove the destionation folder before recreating it to place any copied files in it.
- Git hub token currently not working as ENV use variable auth_token
