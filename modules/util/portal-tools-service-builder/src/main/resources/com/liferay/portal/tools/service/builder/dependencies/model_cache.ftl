package ${packagePath}.model.impl;

import ${apiPackagePath}.model.${entity.name};

<#if entity.hasCompoundPK()>
	import ${apiPackagePath}.service.persistence.${entity.name}PK;
</#if>

import aQute.bnd.annotation.ProviderType;

import com.liferay.portal.kernel.model.CacheModel;
import com.liferay.portal.kernel.model.MVCCModel;
import com.liferay.portal.kernel.util.HashUtil;
import com.liferay.portal.kernel.util.StringBundler;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;
import java.io.Serializable;

import java.util.Date;
import java.util.Map;

/**
 * The cache model class for representing ${entity.name} in entity cache.
 *
 * @author ${author}
 * @see ${entity.name}
<#if classDeprecated>
 * @deprecated ${classDeprecatedComment}
</#if>
 * @generated
 */

<#if classDeprecated>
	@Deprecated
</#if>

@ProviderType
public class ${entity.name}CacheModel implements CacheModel<${entity.name}>, Externalizable
	<#if entity.isMvccEnabled()>
		, MVCCModel
	</#if>

	{

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}

		if (!(obj instanceof ${entity.name}CacheModel)) {
			return false;
		}

		${entity.name}CacheModel ${entity.varName}CacheModel = (${entity.name}CacheModel)obj;

		<#if entity.hasPrimitivePK(false)>
			<#if entity.isMvccEnabled()>
				if ((${entity.PKVarName} == ${entity.varName}CacheModel.${entity.PKVarName}) && (mvccVersion == ${entity.varName}CacheModel.mvccVersion)) {
			<#else>
				if (${entity.PKVarName} == ${entity.varName}CacheModel.${entity.PKVarName}) {
			</#if>
		<#else>
			<#if entity.isMvccEnabled()>
				if (${entity.PKVarName}.equals(${entity.varName}CacheModel.${entity.PKVarName}) && (mvccVersion == ${entity.varName}CacheModel.mvccVersion)) {
			<#else>
				if (${entity.PKVarName}.equals(${entity.varName}CacheModel.${entity.PKVarName})) {
			</#if>
		</#if>

			return true;
		}

		return false;
	}

	@Override
	public int hashCode() {
		<#if entity.isMvccEnabled()>
			int hashCode = HashUtil.hash(0, ${entity.PKVarName});

			return HashUtil.hash(hashCode, mvccVersion);
		<#else>
			return HashUtil.hash(0, ${entity.PKVarName});
		</#if>
	}

	<#if entity.isMvccEnabled()>
		@Override
		public long getMvccVersion() {
			return mvccVersion;
		}

		@Override
		public void setMvccVersion(long mvccVersion) {
			this.mvccVersion = mvccVersion;
		}
	</#if>

	@Override
	public String toString() {
		StringBundler sb = new StringBundler(${(entity.regularColList?size - entity.blobList?size) * 2 + 1});

		<#list entity.regularColList as column>
			<#if !stringUtil.equals(column.type, "Blob")>
				<#if column_index == 0>
					sb.append("{${column.name}=");
					sb.append(${column.name});
				<#elseif column_has_next>
					sb.append(", ${column.name}=");
					sb.append(${column.name});
				<#else>
					sb.append(", ${column.name}=");
					sb.append(${column.name});
					sb.append("}");
				</#if>
			</#if>
		</#list>

		return sb.toString();
	}

	@Override
	public ${entity.name} toEntityModel() {
		${entity.name}Impl ${entity.varName}Impl = new ${entity.name}Impl();

		<#list entity.regularColList as column>
			<#if !stringUtil.equals(column.type, "Blob")>
				<#if stringUtil.equals(column.type, "Date")>
					if (${column.name} == Long.MIN_VALUE) {
						${entity.varName}Impl.set${column.methodName}(null);
					}
					else {
						${entity.varName}Impl.set${column.methodName}(new Date(${column.name}));
					}
				<#else>
					<#if stringUtil.equals(column.type, "String")>
						if (${column.name} == null) {
							${entity.varName}Impl.set${column.methodName}("");
						}
						else {
							${entity.varName}Impl.set${column.methodName}(${column.name});
						}
					<#else>
						${entity.varName}Impl.set${column.methodName}(${column.name});
					</#if>
				</#if>
			</#if>
		</#list>

		${entity.varName}Impl.resetOriginalValues();

		<#list cacheFields as cacheField>
			<#assign methodName = serviceBuilder.getCacheFieldMethodName(cacheField) />

			${entity.varName}Impl.set${methodName}(${cacheField.name});
		</#list>

		return ${entity.varName}Impl;
	}

	@Override
	public void readExternal(ObjectInput objectInput) throws
		<#assign throwsClassNotFoundException = false />

		<#list entity.regularColList as column>
			<#if column.primitiveType>
			<#elseif stringUtil.equals(column.type, "Date")>
			<#elseif stringUtil.equals(column.type, "String")>
			<#elseif !stringUtil.equals(column.type, "Blob")>
				<#assign throwsClassNotFoundException = true />
			</#if>
		</#list>

		<#if (cacheFields?size > 0)>
			<#assign throwsClassNotFoundException = true />
		</#if>

		<#if throwsClassNotFoundException>
			ClassNotFoundException,
		</#if>

		IOException {

		<#list entity.regularColList as column>
			<#if column.primitiveType>
				<#assign columnPrimitiveType = serviceBuilder.getPrimitiveType(column.genericizedType) />

				${column.name} = objectInput.read${textFormatter.format(columnPrimitiveType, 6)}();
			<#elseif stringUtil.equals(column.type, "Date")>
				${column.name} = objectInput.readLong();
			<#elseif stringUtil.equals(column.type, "String")>
				${column.name} = objectInput.readUTF();
			<#elseif !stringUtil.equals(column.type, "Blob")>
				${column.name} = (${column.genericizedType})objectInput.readObject();
			</#if>
		</#list>

		<#list cacheFields as cacheField>
			${cacheField.name} = (${serviceBuilder.getGenericValue(cacheField.type)})objectInput.readObject();
		</#list>

		<#if entity.hasCompoundPK()>
			${entity.PKVarName} = new ${entity.PKClassName}(

				<#list entity.PKList as column>
					${column.name}

					<#if column_has_next>
						,
					</#if>
				</#list>

				);
		</#if>
	}

	@Override
	public void writeExternal(ObjectOutput objectOutput) throws IOException {
		<#list entity.regularColList as column>
			<#if column.primitiveType>
				<#assign columnPrimitiveType = serviceBuilder.getPrimitiveType(column.genericizedType) />

				objectOutput.write${textFormatter.format(columnPrimitiveType, 6)}(${column.name});
			<#elseif stringUtil.equals(column.type, "Date")>
				objectOutput.writeLong(${column.name});
			<#elseif stringUtil.equals(column.type, "String")>
				if (${column.name} == null) {
					objectOutput.writeUTF("");
				}
				else {
					objectOutput.writeUTF(${column.name});
				}
			<#elseif !stringUtil.equals(column.type, "Blob")>
				objectOutput.writeObject(${column.name});
			</#if>
		</#list>

		<#list cacheFields as cacheField>
			objectOutput.writeObject(${cacheField.name});
		</#list>
	}

	<#list entity.regularColList as column>
		<#if !stringUtil.equals(column.type, "Blob")>
			<#if stringUtil.equals(column.type, "Date")>
				public long ${column.name};
			<#else>
				<#assign columnPrimitiveType = serviceBuilder.getPrimitiveType(column.genericizedType) />

				public ${columnPrimitiveType} ${column.name};
			</#if>
		</#if>
	</#list>

	<#list cacheFields as cacheField>
		public ${serviceBuilder.getGenericValue(cacheField.type)} ${cacheField.name};
	</#list>

	<#if entity.hasCompoundPK()>
		public transient ${entity.name}PK ${entity.PKVarName};
	</#if>

}