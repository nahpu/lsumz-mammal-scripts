# nahpu-scripts
Scripts to clean NAHPU export data. 

## Requirements

1. RStudio
2. R interpreter
3. Terminal app (optional)
4. GitHub account (optional)
5. GH Cli (optional)
6. Git (optional)

## Steps

### 1. Clone this repository

You can manually download it from the GitHub repo page or use [gh cli](https://cli.github.com/).

If you are using gh cli. After you authenticate your github login. Do:

```
gh repo clone hhandika/nahpu-scripts
```

You can also use git:

```
git clone https://github.com/hhandika/nahpu-scripts.git
```

### 2. Export `NAHPU` specimen record.

On Nahpu, open the project data. Then, go to the menu. Select export records. In the export record page, change the `Record type` to `Specimen Records`, `Taxon group` to `Mammals`, `Format` to `.csv`. Feel free to name it how ever make sense to you.

### 3. Add `specimen_record.csv` 

After you export `NAHPU` specimen records. Add the csv file to `data` folder in the `nahpu-script` directory. Read the `readme.txt` file inside to folder to understand how git handle the file in the folder.

### 4. Open `nahpu-scripts.Rproj` in RStudio

We recommend doing this to ensure that the path works as expected when running the script. We use r-package [`here`]() to provide closs-platform file paths.

### 5. Open `specify7_upload.Rmd`

The file is located in the folder `R/lsumz_mammals/`.

### 6. Update the input file path

The only part of the script you need to change is the file name of the input file.

### 7. Execute the script

Follow the instruction to execute the script in the `specify7_upload.Rmd` file

### 8. Inspect the results

The resulting file is stored in the `results` folder. We recommend to do final check in the file. By default, `NAHPU` only put measurement in bracket for tail crop measurements. Other inaccuracy will be left as without bracket. Match the bracket with the accuracy note. Future `NAHPU` update is planned to match the bracket based on the inaccuracy noted by the users.

### 9. Upload to Specify

Ask the PI. :stuck_out_tongue_winking_eye:

