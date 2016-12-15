/*
 * The MIT License (MIT)
 * 
 * Copyright © 2016 Emily Mabrey
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 */
package org.github.emabrey.emabrey_parent.build_resources;

import java.io.InputStream;
import java.net.URL;
import java.util.Collections;
import java.util.EnumMap;
import java.util.Map;

/**
 * Provides access to the resources for the emabrey-parent Maven build which are located within this package of the JAR.
 *
 * @author Emily Mabrey <emilymabrey93@gmail.com>
 */
public final class BuildResources {

    /**
     * The build resources of the emabrey-parent Maven project which are located on the class path.
     */
    public static enum BuildResource {

        /**
         * A CSS file containing the stylesheet for use by the maven-javadoc-plugin.
         */
        JAVADOC_STYLESHEET,
        /**
         * The MIT open source license for use by the license-maven-plugin.
         */
        MIT_LICENSE,
        /**
         * The EPL proprietary license for use by the license-maven-plugin.
         */
        EPL_LICENSE;

    }
    
    /**
     * Maps each {@link BuildResource} to a file name. This mapping is unmodifiable, any additions
     * or changes to the mapping must happen within the static block of the {@link BuildResources} class
     * which populates this {@link Map}.
     */
    private static final Map<BuildResource, String> resourceNames;

    /**
     * Populates the {@link #resourceNames} map before making it unmodifiable.
     */
    static
    {
        EnumMap<BuildResource, String> enumNameMap = new EnumMap<>(BuildResource.class);
        enumNameMap.put(BuildResource.JAVADOC_STYLESHEET, "javadoc.css");
        enumNameMap.put(BuildResource.MIT_LICENSE,"MIT.txt");
        enumNameMap.put(BuildResource.EPL_LICENSE,"EPL.txt");
        resourceNames = Collections.unmodifiableMap(enumNameMap);
    }

    /**
     * Provides the {@link URL} location of the class resource specified by the given {@link BuildResource}.
     *
     * @param resource The build resource to locate
     * @return The class path location of the specified build resource
     */
    public static URL getResourceLocation(BuildResource resource) {
        return BuildResources.class.getResource(resourceNames.get(resource));
    }

    /**
     * Provides an {@link InputStream} containing the contents of the class resource specified by the given
     * {@link BuildResource}.
     *
     * @param resource The build resource to locate
     * @return The content of the specified build resource
     */
    public static InputStream getResourceContent(BuildResource resource) {
        return BuildResources.class.getResourceAsStream(resourceNames.get(resource));
    }

    /**
     * Private constructor that marks this final class as totally uninitializable.
     * 
     * @throws InstantiationException Should the constructor somehow be called, this exception is the result
     */
    private BuildResources() throws InstantiationException {
        throw new InstantiationException("This final class has a private constructor which should not be initialized");
    }

}
