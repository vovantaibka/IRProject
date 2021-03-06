package webapp;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import org.apache.commons.configuration2.ex.ConfigurationException;

import java.io.File;

public class Configs {
    private static Configuration config = null;

    public static Configuration getInstance() {
        if (config == null) {
            Configurations configs = new Configurations();
            try {
                config = configs.properties(new File("/home/francy/IdeaProjects/InformationRetrievalProject/conf/searcher.conf"));
            } catch (ConfigurationException e) {
                e.printStackTrace();
            }
        }
        return config;
    }
}
