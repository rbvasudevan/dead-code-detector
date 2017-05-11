package com.devfactory.deadcodedetector.config;

import com.google.common.base.CaseFormat;
import org.hibernate.boot.model.naming.Identifier;
import org.hibernate.boot.model.naming.ImplicitBasicColumnNameSource;
import org.hibernate.boot.model.naming.ImplicitEntityNameSource;
import org.hibernate.boot.model.naming.ImplicitNamingStrategyJpaCompliantImpl;

/**
 * This class applies a custom naming strategy to Java JPA/Hibernate Mapping to DDL Java. For table
 * names it transforms the class name to lower-case and adds the prefix <code>Constants.APP_NAME +
 * "_%s"</code>. For column names it transforms the attribute name to snake case. This strategy will
 * only be applied when the annotations <code>@Table(name=Constants.APP_NAME + "%s")</code> or
 * <code>@Column(name=Constants.APP_NAME + "%s")</code> is not present.
 */
public class JpaNamingStrategy extends ImplicitNamingStrategyJpaCompliantImpl {

    private static final String TABLE_NAME_PREFIX = Constants.APP_NAME + "_%s";

    @Override
    public Identifier determinePrimaryTableName(ImplicitEntityNameSource source) {
        String entityName = transformEntityName(source.getEntityNaming());
        return Identifier.toIdentifier(classToTableName(entityName));
    }

    @Override
    public Identifier determineBasicColumnName(ImplicitBasicColumnNameSource source) {
        String transformAttributePath = transformAttributePath(source.getAttributePath());
        return Identifier.toIdentifier(
                CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, transformAttributePath));
    }

    private String classToTableName(String className) {
        return String.format(TABLE_NAME_PREFIX,
                CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, className.toLowerCase()));
    }
}
