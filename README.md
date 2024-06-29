# Sleeping Dogs Definitive Edition 3D Model Importer

This tool is designed to import and export 3D character models from the game binary of **Sleeping Dogs: Definitive Edition for PC**, using Maxscript.

## Overview

The tool is developed to parse and import 3D model data from the game files of Sleeping Dogs: Definitive Edition. It was created in response to several requests from a user named ShadowWolf. This tool utilizes and extends code structures available from the **[SDmodding GitHub repository](https://github.com/SDmodding)**, which were instrumental in deciphering the game’s file format.

## Features

- **Model Import:** Import 3D models directly from game binaries.
- **Model Export:** Export 3D models directly to game binaries.
- **Data Parsing:** Extracts mesh information, vertices, normals, textures, and face indices.
- **Compatibility:** Works with **3DS Max** for further editing and manipulation.

## Requirements

- **3DS Max**: Version 2016 or later.
- **Maxscript**: Ensure that your 3DS Max environment supports Maxscript.

## Installation

1. **Download** the Maxscript file from this repository.
2. **Open** 3DS Max.
3. **Run** the Maxscript file by dragging it into the viewport or using the Maxscript editor.

## Usage

### Interface Overview

The interface is divided into two groups: **Skeleton** and **Mesh**.

### Skeleton Group

- **Load:** Opens the `CharacterRig.bin` file, which contains all the skeletons in the game, and loads them into a dropdown list.
- **Skeletons Dropdownlist:** Select a skeleton from the list that suits your model.
- **Reset Scene:** Deletes everything in the 3DS Max scene when the **Build** button is pressed.
- **Build:** Builds the skeleton selected in the dropdown list.

### Mesh Group

- **Import:** Opens a `*.perm.bin` binary model from the game and builds the mesh into the scene. Normals, tangents, more than one UV channel, morph targets, materials, textures, and vertex colors are NOT supported. Weights and UVs are supported.
- **Export:** Work in progress, will eventually export a new model to `*.perm.bin`.

### Steps to Import Models

1. **Load the script** in 3DS Max.
2. **Select the CharacterRig.bin** file using the **Load** button in the **Skeleton** group.
3. **Choose a skeleton** from the dropdown list that matches your model.
4. **Check Reset Scene** if you want to clear the current scene.
5. **Press Build** to create the skeleton in the scene.
6. **Select the `*.perm.bin`** file using the **Import** button in the **Mesh** group.
7. The mesh will be built into the scene with weights and UVs applied.

### Steps to Export Models

1. **Load the script** in 3DS Max.
2. You will need to have imported an existing character to replace
3. **Press Export** to pick a destintion file
5. The mesh will saved to the new file

## Acknowledgements

Special thanks to the **[SDmodding](https://github.com/SDmodding)** community for their invaluable resources and code structures that significantly aided in developing this tool.

## Disclaimer

I do not play Sleeping Dogs: Definitive Edition and have no personal interest in the game. This tool was developed purely based on the requests from the modding community.
