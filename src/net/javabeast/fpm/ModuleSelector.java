package net.javabeast.fpm;

import javax.swing.*;
import java.awt.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ModuleSelector extends JFrame {

    private final List<JCheckBox> checkBoxes = new ArrayList<>();
    public ModuleSelector(ModuleSelectorResolveFunction resolveFunction, String... modules) {
        setLayout(new GridLayout(modules.length + 1, 2));
        setLocation(500, 500);
        for (String module : modules) {
            JCheckBox checkBox = new JCheckBox(module);
            checkBoxes.add(checkBox);
            add(checkBox);
        }
        JButton button = new JButton("OK");
        button.addActionListener(e -> {
            button.setText("CLICKED!");
            List<String> modules1 = new ArrayList<>();
            for (JCheckBox checkBox : checkBoxes) {
                if (checkBox.isSelected()) {
                    modules1.add(checkBox.getText());
                }
            }
            try {
                System.out.println("resolving...");
                resolveFunction.resolve(modules1);
            } catch (IOException exception) {
                throw new RuntimeException(exception);
            }
            setVisible(false);
            System.exit(0);
        });
        add(button);
        setTitle("SELECT MODULES");
        setSize(getPreferredSize());
        setVisible(true);
    }
}
