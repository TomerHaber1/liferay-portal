/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.vulcan.resource;

import com.liferay.vulcan.pagination.PageItems;

import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Function;

/**
 * Instances of this interface will hold information about the routes supported
 * for a certain {@link Resource}.
 *
 * <p>
 * All of the methods in this interface returns functions to get the different
 * endpoints of the {@link Resource}.
 * </p>
 *
 * <p>
 * Instances of this interface should always be created by using a {@link
 * com.liferay.vulcan.resource.builder.RoutesBuilder}.
 * </p>
 *
 * @author Alejandro Hernández
 * @see    com.liferay.vulcan.resource.builder.RoutesBuilder
 */
public interface Routes<T> {

	/**
	 * Returns the function used to create the filtered page of a {@link
	 * Resource}. Returns <code>Optional#empty()</code> if the endpoint wasn't
	 * added through the {@link
	 * com.liferay.vulcan.resource.builder.RoutesBuilder}.
	 *
	 * <p>
	 * This function will have as its only parameter another function which must
	 * be able to provide instances of classes that have a {@link
	 * com.liferay.vulcan.provider.Provider}.
	 * </p>
	 *
	 * @return the function used to create the filtered page, if present;
	 *         <code>Optional#empty()</code> otherwise.
	 */
	public Optional<Function<Function<Class<?>, Optional<?>>, PageItems<T>>>
		getFilteredPageItemsFunctionOptional(String filterClassName);

	/**
	 * Returns the function used to create the single model of a {@link
	 * Resource}. Returns <code>Optional#empty()</code> if the endpoint wasn't
	 * added through the {@link
	 * com.liferay.vulcan.resource.builder.RoutesBuilder}.
	 *
	 * <p>
	 * This function will have as its only parameter another function which must
	 * be able to convert String identifiers to a class that have a {@link
	 * com.liferay.vulcan.converter.Converter}.
	 * </p>
	 *
	 * <p>
	 * Once the first function has been applied, the result function will have
	 * as its only parameter another function which must be able to provide
	 * instances of classes that have a {@link
	 * com.liferay.vulcan.provider.Provider}.
	 * </p>
	 *
	 * @return the function used to create the single model, if present;
	 *         <code>Optional#empty()</code> otherwise.
	 */
	public Optional<Function<BiFunction<Class<?>, String, ?>,
		Function<Function<Class<?>, Optional<?>>, Function<String, T>>>>
			getModelFunctionOptional();

	/**
	 * Returns the function used to create the page of a {@link Resource}.
	 * Returns <code>Optional#empty()</code> if the endpoint wasn't added
	 * through the {@link com.liferay.vulcan.resource.builder.RoutesBuilder}.
	 *
	 * <p>
	 * This function will have as its only parameter another function which must
	 * be able to provide instances of classes that have a {@link
	 * com.liferay.vulcan.provider.Provider}.
	 * </p>
	 *
	 * @return the function used to create the page, if present;
	 *         <code>Optional#empty()</code> otherwise.
	 */
	public Optional<Function<Function<Class<?>, Optional<?>>, PageItems<T>>>
		getPageItemsFunctionOptional();

}