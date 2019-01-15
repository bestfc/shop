/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.audit;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.springframework.core.ResolvableType;
import org.springframework.util.Assert;
import org.springframework.util.ClassUtils;

import net.shopxx.util.SpringUtils;

/**
 * Audit审计实体类监听器
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class AuditingEntityListener {

	/**
	 * 审计者Provider缓存
	 */
	@SuppressWarnings("rawtypes")
	private static final Map<Class<?>, AuditorProvider> AUDITOR_PROVIDER_CACHE = new ConcurrentHashMap<>();

	/**
	 * 保存前处理
	 * 
	 * @param entity
	 *            实体对象
	 */
	@SuppressWarnings("unchecked")
	@PrePersist
	public void prePersist(Object entity) {
		AuditingMetadata auditingMetadata = AuditingMetadata.getAuditingMetadata(entity.getClass());
		if (!auditingMetadata.isAuditable()) {
			return;
		}

		List<AuditingMetadata.Property> createdByProperties = auditingMetadata.getCreatedByProperties();
		List<AuditingMetadata.Property> createdDateProperties = auditingMetadata.getCreatedDateProperties();
		List<AuditingMetadata.Property> lastModifiedByProperties = auditingMetadata.getLastModifiedByProperties();
		List<AuditingMetadata.Property> lastModifiedDateProperties = auditingMetadata.getLastModifiedDateProperties();

		List<AuditingMetadata.Property> byProperties = (List<AuditingMetadata.Property>) CollectionUtils.union(createdByProperties, lastModifiedByProperties);
		List<AuditingMetadata.Property> dateProperties = (List<AuditingMetadata.Property>) CollectionUtils.union(createdDateProperties, lastModifiedDateProperties);

		if (CollectionUtils.isNotEmpty(byProperties)) {
			for (AuditingMetadata.Property property : byProperties) {
				AuditorProvider<?> auditorProvider = getAuditorProvider(property.getType());
				Object currentAuditor = auditorProvider != null ? auditorProvider.getCurrentAuditor() : null;
				if (currentAuditor != null) {
					property.setValue(entity, currentAuditor);
				}
			}
		}
		if (CollectionUtils.isNotEmpty(dateProperties)) {
			Date now = new Date();
			for (AuditingMetadata.Property property : dateProperties) {
				property.setValue(entity, now);
			}
		}
	}

	/**
	 * 更新前处理
	 * 
	 * @param entity
	 *            实体对象
	 */
	@PreUpdate
	public void preUpdate(Object entity) {
		AuditingMetadata auditingMetadata = AuditingMetadata.getAuditingMetadata(entity.getClass());
		if (!auditingMetadata.isAuditable()) {
			return;
		}

		List<AuditingMetadata.Property> lastModifiedByProperties = auditingMetadata.getLastModifiedByProperties();
		List<AuditingMetadata.Property> lastModifiedDateProperties = auditingMetadata.getLastModifiedDateProperties();

		if (CollectionUtils.isNotEmpty(lastModifiedByProperties)) {
			for (AuditingMetadata.Property property : lastModifiedByProperties) {
				AuditorProvider<?> auditorProvider = getAuditorProvider(property.getType());
				if (auditorProvider != null) {
					Object currentAuditor = auditorProvider.getCurrentAuditor();
					if (currentAuditor != null) {
						property.setValue(entity, currentAuditor);
					}
				}
			}
		}
		if (CollectionUtils.isNotEmpty(lastModifiedDateProperties)) {
			Date now = new Date();
			for (AuditingMetadata.Property property : lastModifiedDateProperties) {
				property.setValue(entity, now);
			}
		}
	}

	/**
	 * 获取审计者Provider
	 * 
	 * @param auditorClass
	 *            审计者类型
	 * @return 审计者Provider，若不存在则返回null
	 */
	@SuppressWarnings("rawtypes")
	private AuditorProvider<?> getAuditorProvider(Class<?> auditorClass) {
		Assert.notNull(auditorClass);

		if (AUDITOR_PROVIDER_CACHE.containsKey(auditorClass)) {
			return AUDITOR_PROVIDER_CACHE.get(auditorClass);
		}

		Map<String, AuditorProvider> auditorProviderMap = SpringUtils.getBeansOfType(AuditorProvider.class);
		if (MapUtils.isNotEmpty(auditorProviderMap)) {
			for (AuditorProvider<?> auditorProvider : auditorProviderMap.values()) {
				ResolvableType resolvableType = ResolvableType.forClass(ClassUtils.getUserClass(auditorProvider));
				Class<?> genericClass = resolvableType.as(AuditorProvider.class).getGeneric().resolve();
				if (genericClass != null && genericClass.equals(auditorClass)) {
					AUDITOR_PROVIDER_CACHE.put(auditorClass, auditorProvider);
					return auditorProvider;
				}
			}
		}
		return null;
	}

}