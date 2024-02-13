package net.javabeast.fpm;

import com.sun.security.auth.login.ConfigFile;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.swing.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class Main {


    private static List<String> clientFiles = new ArrayList<>();
    private static List<String> serverFiles = new ArrayList<>();
    private static List<String> sharedFiles = new ArrayList<>();

    private static StringBuilder metaBuilder = new StringBuilder();
    private static StringBuilder configBuilder = new StringBuilder();
    private static StringBuilder fxBuilder = new StringBuilder();

    private static File createFile(String path, String fileName) throws IOException {
        File file = new File(path + "\\" + fileName);
        file.createNewFile();
        return file;
    }

    private static void writeContent(File file, String content) throws IOException {
        FileWriter writer = new FileWriter(file);
        writer.write(content.trim() + "\n");
        writer.flush();
    }

    private static void createFXManifest(String path, String name, String client, String server, String shared, String append) throws IOException {
        File file = createFile(path, "fxmanifest.lua");
        writeContent(file, ("fx_version 'cerulean'\n" +
                "game 'gta5'\n" +
                "\n" +
                "name '@name'\n" +
                "description 'generated with fiveM project manager'\n" +
                "author 'java3east'\n" +
                "version '1.0'\n" +
                "\n" +
                "shared_scripts {\n" +
                "    @shared\n" +
                "}\n" +
                "\n" +
                "client_scripts {\n" +
                "    @client\n" +
                "}\n" +
                "\n" +
                "server_scripts {\n" +
                "    @server\n" +
                "}\n\n").replace("@name", name).replace("@shared", shared).replace("@client", client).replace("@server", server) + append);
    }

    private static String getFileContent(String path) {
        File file = new File(path);
        try {
            boolean ignore = false;
            Scanner scanner = new Scanner(file);
            StringBuilder content = new StringBuilder();
            while (scanner.hasNext()) {
                String nextLine = scanner.nextLine();
                if (nextLine.startsWith("---@fpm-ignore-start")) {
                    ignore = true;
                    continue;
                }
                if (nextLine.startsWith("---@fpm-ignore-end")) {
                    ignore = false;
                    continue;
                }
                if (ignore) {
                    continue;
                }
                content.append(nextLine).append("\n");
            }
            return content.toString();
        } catch (Exception exception) {
            return "";
        }
    }

    private static File createFolder(String path, String name) {
        File folder = new File(path + "\\" + name);
        folder.mkdirs();
        return folder;
    }

    private static boolean cloneIfExists(String fromPath, String folderName, String moduleName, String target, List<String> list, String prefix, String sub) {
        File sourceFolder = new File(fromPath + "\\" + moduleName + "\\" + folderName + "\\" + sub);
        System.out.println( prefix + "'" + sourceFolder.getPath() + "'");
        if (sourceFolder.exists()) {
            Arrays.stream(sourceFolder.listFiles()).forEach(moduleFile -> {
                try {
                    if (!moduleFile.isDirectory()) {
                        System.out.println(prefix + " | '" + moduleFile.getPath());
                        String content = getFileContent(moduleFile.getPath());
                        File file;
                        File folder;
                        if (!moduleFile.getName().contains(".lua")) {
                            folder = createFolder(target, "ui" + "\\" + sub.replace("ui\\", ""));
                            if (!moduleFile.getName().equals(".ignore")) {
                                file = createFile(folder.getPath(), moduleFile.getName());
                                writeContent(file, content);
                            }
                        } else {
                            folder = createFolder(target + "\\" + folderName + "\\modules\\", moduleName + "\\" + sub);
                            file = createFile(folder.getPath(), moduleFile.getName());
                            content =
                                    "-- ################################################################## --\n" +
                                    "-- #                                                                # --\n" +
                                    "-- #    This file is a part of the FPM (FiveM Project Manager),     # --\n" +
                                    "-- #                     created by Java3east.                      # --\n" +
                                    "-- #                                                                # --\n" +
                                    "-- ################################################################## --\n\n"
                                    + content;

                            writeContent(file, content);
                            if (list == null) return;
                            list.add((folderName + "\\modules\\" + moduleName + "\\" + file.getName()).replace("\\", "/"));
                        }
                    } else {
                        cloneIfExists(fromPath, folderName, moduleName, target, list, prefix + " | ", sub + moduleFile.getName() + "\\");
                    }
                } catch (IOException e) { System.out.println("error: " + e.getMessage()); }
            });
            return true;
        }
        return false;
    }

    private static void importModule(String name, String modulePath, String target) {
        cloneIfExists(modulePath, "shared", name, target, sharedFiles, " | ", "");
        cloneIfExists(modulePath, "server", name, target, serverFiles, " | ", "");
        cloneIfExists(modulePath, "client", name, target, clientFiles, " | ", "");

        String metaContent = getFileContent(modulePath + "\\" + name + "\\meta.lua");
        if (!metaContent.isEmpty()) {
            metaBuilder.append(metaContent).append("\n");
        }

        String configContent = getFileContent(modulePath + "\\" + name + "\\config.lua");
        if (!configContent.isEmpty()) {
            configBuilder.append(configContent).append("\n");
        }

        String fxContent = getFileContent(modulePath + "\\" + name + "\\fxmanifest.lua");
        if (!fxContent.isEmpty()) {
            fxBuilder.append(fxContent).append("\n");
        }

        System.out.println("\n");
    }

    private static void loadDependencies(List<String> assembled, String module, String path) {
        // only import if not imported yet
        if (assembled.contains(module))  return;

        System.out.println("loading dependencies of '" + module + "' ...");

        // get the module json
        JSONObject moduleJson = new JSONObject(getFileContent(path + "\\" + module + "\\module.json"));

        // get an array of required modules
        JSONArray requiredModules = moduleJson.getJSONArray("require");

        // loop through required modules & load recursive
        for (int index = 0; index < requiredModules.length(); index++) {
            // module at index
            String requiredModule = requiredModules.getString(index);

            // load dependencies
            loadDependencies(assembled, requiredModule, path);
        }

        // add module
        assembled.add(module);
    }

    public static void main(String[] args) throws IOException, InterruptedException {
        String configString = getFileContent("./config.json");
        JSONObject jsonObject = new JSONObject(configString.toString());

        String path = jsonObject.getString("PROJECTS_FOLDER");
        String modulesPath = jsonObject.getString("MODULE_FOLDER");
        JSONArray availableModules = jsonObject.getJSONArray("MODULES");

        String projectName = JOptionPane.showInputDialog("resource name");
        if (projectName == null || projectName.isEmpty()) {
            return;
        }

        File folder = createFolder(path, projectName);

        if (folder.getAbsolutePath().equals(new File(path).getAbsolutePath())) return;

        String[] moduleNames = new String[availableModules.length()];
        for (int i = 0; i < availableModules.length(); i++) {
            moduleNames[i] = availableModules.getString(i);
        }

        File vsConfigFolder = createFolder(path, projectName + "/.vscode");
        File vsConfigFile = createFile(vsConfigFolder.getPath(), "settings.json");
        writeContent(vsConfigFile, getFileContent(modulesPath + "\\.vscode\\settings.json"));

        File metaFile = createFile(folder.getPath(), "meta.lua");
        metaBuilder.append(
                "-- ################################################################## --\n" +
                "-- #                                                                # --\n" +
                "-- #    This file is a part of the FPM (FiveM Project Manager),     # --\n" +
                "-- #                     created by Java3east.                      # --\n" +
                "-- #                                                                # --\n" +
                "-- ################################################################## --\n\n"
        );
        File configFile = createFile(folder.getPath(), "config.lua");
        configBuilder.append(
                "-- ################################################################## --\n" +
                "-- #                                                                # --\n" +
                "-- #    This file is a part of the FPM (FiveM Project Manager),     # --\n" +
                "-- #                     created by Java3east.                      # --\n" +
                "-- #                                                                # --\n" +
                "-- ################################################################## --\n\n"
        );

        sharedFiles.add("config.lua");
        sharedFiles.add("open.lua");

        new ModuleSelector(modules -> {
            System.out.println("importing modules...");

            // get all modules & required modules
            List<String> allModules = new ArrayList<>();
            for (String module : modules) {
                loadDependencies(allModules, module, modulesPath);
            }
            modules = allModules;


            StringBuilder openContent = new StringBuilder();
            openContent.append(
                    "-- ################################################################## --\n" +
                    "-- #                                                                # --\n" +
                    "-- #    This file is a part of the FPM (FiveM Project Manager),     # --\n" +
                    "-- #                     created by Java3east.                      # --\n" +
                    "-- #                                                                # --\n" +
                    "-- ################################################################## --\n\n"
            );
            openContent.append("---Open functions, feel free to edit.").append("\n").append("Open = {}").append("\n\n");

            configBuilder.append("---@diagnostic disable: missing-fields\nConfig = {}\n\n");

            for (String module : modules) {
                System.out.println("loading:\nMODULE '" + module + "'");

                importModule(module, modulesPath, folder.getPath());

                String moduleOpenContent = getFileContent(modulesPath + "\\" + module + "\\open.lua");
                if (!moduleOpenContent.isEmpty()) {
                    openContent.append(moduleOpenContent).append("\n\n");
                }
            }
            StringBuilder sharedString = new StringBuilder();
            sharedFiles.forEach(filePath -> {
                sharedString.append("    '").append(filePath).append("',\n");
            });

            StringBuilder serverString = new StringBuilder();
            serverFiles.forEach(filePath -> {
                serverString.append("    '").append(filePath).append("',\n");
            });

            StringBuilder clientString = new StringBuilder();
            clientFiles.forEach(filePath -> {
                clientString.append("    '").append(filePath).append("',\n");
            });

            File openFile = createFile(folder.getPath(), "open.lua");
            writeContent(openFile, openContent.toString());

            writeContent(metaFile, metaBuilder.toString());
            writeContent(configFile, configBuilder.toString());

            // fxmanifest
            createFXManifest(folder.getPath(), projectName, clientString.toString().trim(), serverString.toString().trim(), sharedString.toString().trim(), fxBuilder.toString().trim());
        }, moduleNames);
    }
}
