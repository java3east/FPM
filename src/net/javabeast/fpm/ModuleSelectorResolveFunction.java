package net.javabeast.fpm;

import java.io.IOException;
import java.util.List;

@FunctionalInterface
public interface ModuleSelectorResolveFunction {
    void resolve(List<String> modules) throws IOException;
}
