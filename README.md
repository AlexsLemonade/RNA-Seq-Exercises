# CCDL RNA-Seq-Exercises

The [Childhood Cancer Data Lab](ccdatalab.org) is developing a series of short course modules to train researchers studying childhood cancer to perform reproducible analyses.

This module focuses on the analysis of RNA-seq data.
We structured this series to include one day on the analysis of a dataset selected by a course director, one day on the analysis of the participants own RNA-seq dataset, and a half-day to touch on some more advanced topics.
Here is the [schedule](schedule.md) for the workshop.

## Post-Docker Steps

1. In Kitematic, search for "CCDL". Get the training_rnaseq image.
2. Start the training_rnaseq image.
3. Click the settings button.
4. On the network panel you should see that an IP address has been assigned in the PUBLISHED IP:PORT column. [!Published IP](screenshots/all-01-network.png)
5. On the volume panel you should see that a folder has been assigned. This is where output files can be stored so that they will show up on your computer. [!Folder](screenshots/all-02-volume.png)
6. On the advanced panel you should that a TTY is assigned and STDIN will remain open. [!Advanced](screenshots/all-03-advanced.png)
7. Visit the IP address that was listed in the PUBLISHED IP tab in a web browser and you should see an RStudio login. The login information is username: `rstudio` and password: `rstudio`. If you do not see this, raise your hand. [!RStudio](screenshots/all-04-rstudio.png)
