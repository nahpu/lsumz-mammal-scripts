# nahpu-scripts
Scripts to clean and reshape NAHPU export data to align with Specify's comma-delimited (CSV) batch import format. 
It takes seconds to run. However, the automated process to incorporate tissue locations has not yet been implemented. It's done manually for now.

> **Notes**  
> The scripts are fine-tuned to match the input format of the [LSMNS](https://www.lsu.edu/mns/index.php) Mammal database.  
> Feel free to modify them to fit your CSV input format.  
>  
> If you need assistance or are interested in sharing updates in the NAHPU GitHub repository, please don't hesitate to contact us!

## Requirements

1. RStudio
2. R interpreter v4.1.0+
3. Terminal app (optional)
4. GitHub account (optional)
5. GH CLI (optional)
6. Git (optional)

## Steps

### 1. Clone this repository

You can manually download it from the GitHub repo page or use [gh cli](https://cli.github.com/).

If you are using gh cli. After you authenticate your GitHub login, do:

```
gh repo clone hhandika/nahpu-scripts
```

You can also use git:

```
git clone https://github.com/hhandika/nahpu-scripts.git
```

### 2. Export `NAHPU` specimen record.

On Nahpu, open the project data. Then, go to the menu. Select export records. In the export record page, change the `Record type` to `Specimen Records`, `Taxon group` to `Mammals`, `Format` to `.csv`. Feel free to name it however makes sense to you.

### 3. Add `specimen_record.csv` 

After you export `NAHPU` specimen records, add the CSV file to the `data` folder in the `nahpu-script` directory. Read the `readme.txt` file inside the folder to understand how git handles the file in the folder.

### 4. Open `nahpu-scripts.Rproj` in RStudio

We recommend doing this to ensure that the path works as expected when running the script. We use the R package [`here`]() to provide cross-platform file paths.

### 5. Open `specify7_upload.Rmd`

The file is located in the folder `R/lsumz_mammals/`.

### 6. Update the input file path

The only part of the script you need to change is the file name of the input file.

### 7. Execute the script

Follow the instructions to execute the script in the `specify7_upload.Rmd` file

### 8. Inspect the results

The resulting file is stored in the `results` folder. We recommend doing a final check of the file. By default, `NAHPU` only puts measurements in brackets for tail crop measurements. Other inaccuracies will be left without brackets. Match the bracket with the accuracy note. A future `NAHPU` update is planned to match the bracket based on the inaccuracies noted by the users.

### 9. Upload to Specify

Ask the curator or the collection manager. :stuck_out_tongue_winking_eye:

