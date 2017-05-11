package com.devfactory.deadcodedetector.config;

import static org.assertj.core.api.Assertions.assertThat;
import static pl.pojo.tester.api.assertion.Assertions.assertPojoMethodsForAll;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
import pl.pojo.tester.api.assertion.Method;

@RunWith(MockitoJUnitRunner.class)
public class ConfigTest {

    @Test
    public void domainTest() {
        assertPojoMethodsForAll( BaseRestConfig.class,
                JpaNamingStrategy.class, DeadCodeDetectorProperties.class,JpaConfig.class,
                JpaNamingStrategy.class,SwaggerConfig.class)
                .testing(Method.GETTER, Method.SETTER, Method.CONSTRUCTOR)
                .areWellImplemented();
    }
}
