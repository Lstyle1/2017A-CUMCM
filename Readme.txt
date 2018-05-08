£¨Available in Markdown£©

## 2017A-CUMCM
Mathematical modeling solution of 2017A-CUMCM: CT calibration and reconstruction.

### Introduction
The programming language used is MATLAB.

Features:
* Calibration of distance between units;
* Calibration of rotation center;
* Calibration of rotation directions;
* Reconstruction of two different samples(shape, position and absorption rates);
* Design a new template for optimized calibration.

### Contents
* Data: Absorption rates of two unknown samples.

* Doc: Solution paper of this CUMCM topic.

* Fig: All figures used for demonstrations.

* Src: Source codes for calibration, reconstruction and design of a template.

* Toolbox: Astra toolbox for testing different templates.

* Topic: Topic of 2017A-CUMCM and data provided.

### Usage
The main function is `reconstruction.m`.
Outputs:
* Three sinograms and reconstruction images;
* Ten specific absorption rates of two unknown samples and one templates given in excel.

### Dependencies
We used Astra toolbox for new template tests. You can find it here: [Astra Toolbox download page](https://sourceforge.net/projects/astra-toolbox/).

### Toolbox Usage:
Add the mex and tools subdirectories of Astra to your matlab path.
You may need to install the Microsoft Visual Studio 2012 redistributables, which
are included as vcredist_x64.exe .
