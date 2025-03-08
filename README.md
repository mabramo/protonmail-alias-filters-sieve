# ProtonMail Alias Filters Sieve Generator

As if that name isn't confusing enough...
Generate a sieve to be used in ProtonMail filters that will move incoming mail using your ProtonPass aliases to a ProtonMail folder.

## Why

I'll let Proton themselves explain the [benefits of aliasing](https://proton.me/blog/benefits-of-email-aliases).

This script is a workaround for a limitation in ProtonMail filters. Let's say you have some aliases:

- `alias123+amazon@example.com`
- `alias456+facebook@example.com`
- `alias789+xwitter@example.com`

And let's say those aliases (As configured in ProtonPass) forward to your ProtonMail inbox.
Like any other email you receive, without filters those addresses will go to your primary inbox.
So let's set up some filters in ProtonMail.

`alias123+amazon@example.com` should move to a mail folder called "Shopping"
`alias456+facebook@example.com` should move to a mail folder called "Social Media"
`alias789+xwitter@example.com` should move to a mail folder called "Social Media"

No problem! You can get mail sent to those addresses and they will automatically be organized into folders for you. Three aliases, three filters.

But what if we have HUNDREDS of aliases?
And what if you change or delete an existing alias?
Well, you'll have to do that manually as well.

## The Workaround

ProtonMail supports [sieve filters](https://proton.me/support/sieve-advanced-custom-filters)

With sieve filters, we can provide a list of email aliases and map them to a folder name that is based on the ProtonPass vault name. The filter will automatically move emails sent to the alias address to a folder with the same name as the vault the alias address is stored in.
See `examples/example-output.out`

You could update the sieve file totally by hand every time you create or destroy an alias.

Instead, you can generate a new seive filter script using `bash/generate-alias-sieve.sh`

### Which folder will my alias move mail to?

As written, I am mapping the ProtonPass alias vault to a mail folder with the same name.

For example:
`alias123+amazon@example.com` is stored in a ProtonPass vault called "Shopping"

Therefore, the generated sieve script will move mail from `alias123+amazon@example.com` to a mail folder called "Shopping". This does require you to make sure your aliases are organized into vaults. The default vault name in ProtonPass is called "Personal".

## Usage

### Disclaimers

I have only tested this on OSX. It should work on any unix based system. I expect it will work on Windows as well but I don't know what you powershell people do over there and sometimes strings are weird.

### Requirements

- You know how to open the terminal on your computer
- `bash` is installed
- exported CSV data from ProtonPass

NOTE: The exported file from ProtonPass is not encrypted. It contains plain text of your passwords, aliases, and any other information you store in ProtonPass. If you choose to export your data to your local machine, delete it immediately after you are done using it. And I think it goes without saying if you're reading this, don't export your ProtonPass data on a public internet connection. Perhaps in the future I will write another program that supports the encrypted JSON file that you can export from ProtonPass.

### Running the script

- Pull the repo to your machine
    - Or just download `bash/generate-alias-sieve.sh`
    - Or copy and paste the contents of the file directly from github into an `.sh` file on your machine
- run `bash generate-alias-sieve.sh ../path-to-protonpass-csv-file`
- The output file `sieve-filters.out` will be created in your current directory

### Adding the output file to your ProtonMail filters

- Navigate to ProtonMail > All Settings > Filters
- Click `Add sieve filter`
- Copy and paste the contents of `sieve-filters.out` to the sieve filter window in ProtonMail

### Final step

- Delete your exported ProtonPass data from wherever you stored it. Don't just leave it there for anyone at your computer to view.
