# flex-extensions #

Provides a collection of useful Adobe Flex user interface components, charting controls and elements, behaviors, data types and utility classes and methods.

## Behaviors ##

### User Interface ###

* **Populator**

	This behavior tag populates a target Container with item renderer components for each item in a data provider.  Populator watches collections for change events and dynamically adds or removes item renderer components as needed, leveraging an internal item renderer object pool to improve performance.

* **Selectable**

	Similar to the jQuery UI Selectable behavior, this behavior tag manages the selection state for the child components of a target Container.  It supports custom item renderer selection data fields, change events, and single or multiple selection modes.

## User Interface Components ##

### Core ###

* **Button**

	Extends the standard Flex Button component to add support for additional styles, such as `textSelectedColor`.

* **TabBar, Tab**

	Extends the standard Flex TabBar and Tab components to add support for additional styles, such as `textSelectedRollOverColor` and `selectedLabelVerticalOffset`.

* **OverlappingTabBar**

	Extends the TabBar component to support custom skinning requirements where the selected tab should be rendered at the top-most z-order.

### Chart ###

* **DynamicChart, DynamicAxisRenderer**

	Extends the standard Flex charting CartesianChart and AxisRenderer components and adds support for runtime changes to the set of associated AxisRenderers.  Implements workarounds for bugs in the Flex Data Visualization SDK that cause runtime axisRenderer changes to be ignored, and removed axis renderers to cause null pointer exceptions.  Use DynamicChart in place of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) and DynamicAxisRenderer in place of AxisRenderer.

### Chart Controls ###

* **ChartPanControl, ChartZoomInControl, ChartZoomOutControl**

	These custom chart controls can be used in the `<mx:annotationElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to offer direct chart interactivity such as panning by mouse drag, zooming in / out by mouse click, and zooming to a rectangle by mouse drag + click.  These components dispatch ChartPanEvent and ChartZoomEvent events that provide the pan offset, zoom origin or zoom rectangle in data coordinates, which can be used to update the content displayed in the chart as required to achieve the requested interaction.  This component supports CSS styles for custom cursors, strokes and fills.

* **ChartHoverControl, ChartHoverCrossHairControl**

	This custom chart control can be used in the `<mx:annotationElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to detect when the user hovers the mouse over the chart.  These components dispatch ChartHoverEvent events that provide the current hovered x and y coordinates in data coordinates.  ChartHoverControl can be extended to implement custom hover indicator drawing logic.  ChartHoverCrossHairControl extends ChartHoverControl and draws a crosshair or horizontal/vertical line at the hovered location.

### Chart Elements ###

* **AnnotationLine**

	This custom chart element can be used in the `<mx:annotationElements>` or `<mx:backgroundElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to draw a line for the specified data coordinate(s).  This element supports CSS styles for custom line strokes.

* **Background**

	This custom chart element can be used in the `<mx:backgroundElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to draw a custom background within the content area of the chart.  This element supports CSS styles for custom background fills and border strokes.

* **DateTimeGridLines**
	
	This custom chart element can be used in the `<mx:annotationElements>` or `<mx:backgroundElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to draw grid lines at specific date time intervals.  Provides a callback function for evaluating individual time intervals, and supports CSS styles for custom fills, strokes and dash patterns.

* **HighlightedRegion**
	
	This custom chart element can be used in the `<mx:annotationElements>` or `<mx:backgroundElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to draw a custom filled region for the specified x and y value ranges within the content area of the chart.  This element supports CSS styles for custom fills and border strokes.

* **LinearTrendLine**

	This custom chart element can be used in the `<mx:annotationElements>` or `<mx:backgroundElements>` tag of any CartesianChart (AreaChart, ColumnChart, LineChart, etc.) to calculate and draw a trend line for the visible points in the specified series.  This element supports CSS styles for custom line strokes and dash patterns.

* **TruncatedAxisLabelRenderer**

	This custom chart label renderer enables the standard Flex Label 'truncateToFit' behavior, adding a truncation indicator (ex. '...') and truncating label text that exceeds the available chart gutter bounds.
	
### Container ###

* **BoxFrame**

	Extends the standard Flex Box container and modifies its behavior so that it grows its own scrollbars when content exceeds its bounds (rather than depending on or affecting the parent container).

### Date ###

* **DateRangeInput**

	A custom user interface component that allows the user to enter or modify a date range via DateFields, within a specified available date range, with integrated validation.

* **DateRangeSlider**

	A custom user interface component that allows a user to select any number of date ranges, within an available date range, using slider thumbs over a content area to move and resize each selected date range.  An underlying content component may be specified, such as a chart, to appear below the thumbs.  This component supports an extensive set of CSS styles for custom skinning of the slider background, cursors, slider thumbs and grips.

	A DateRangeSlider, with a chart specified as its content, provides functionality comparable to the date range sliders featured in Google and Yahoo Finance.

* **MonthPicker**

	A custom user interface component that allows the user to select a month and year via ComboBoxes, within a specified available data range, with integrated validation.

### Item Renderers ###

* **BoxItemRenderer, CanvasItemRenderer**

	These custom components are special Container implementations for use in custom item renderers for List, DataGrid, Populator, etc. components.  They implement IListItemRenderer, IDropInListItemRenderer, and IDataRenderer, and manage selection and rollover state.  They expose useful properties for binding, such as isMouseOver, isMouseDown, isHighlighted and isSelected.  Additionally, they add style support for custom border skins with 'up', 'over', 'down', 'disabled' states (and the corresponding 'selected' states).

### User Interface Templates ###

* **Group**

	This template is a Box Container that expects a data provider and item renderer factory, and dynamically populates itself with item renderer instances for the items in the specified data provider.  It leverages the Populator behavior.

* **CheckGroup, RadioGroup**

	These templates are Box Containers that expect a data provider, item renderer and selected item(s), dynamically populate themselves with item renderer instances for the items in the specified data provider and manage their selection state.  They support custom item renderer selection data fields and change event types.  They leverage the Populator and Selectable behaviors.  They dispatches Event.CHANGE events when the user changes the selected item.

* **MasterDetails**

	This template manages master and detail components within a divided box.  The detail view can be collapsed and expanded, with animation.

## Data Types ##

* **DateRange**

	Describes a date range between a starting time and an ending time.  Provides useful utility methods for date range related operations, such as determining if the DateRange contains a given Date or intersects another DateRange, and creating Dates and DateRanges that are bounded by the DateRange.

* **FrequencyBin**

	Describes an element of a frequency distribution, including sample value range, frequency and percentage.

* **NumericRange**

	Describes a numeric range between a minimum and maximum value.  Provides useful utility methods for range related operations, such as determining if the numeric range contains a value and partitioning the numeric range into smaller numeric ranges.

* **Option**

	Describes a generic option with a label and a value.

* **Property**

	Describes a property by property path (potentially deeply nested and expressed as dot notation).  Provides methods for verifying the existence of the property and getting and setting the corresponding value for property for a given object instance.

* **TemporalData**, **SampleSet**

	Describes data with a time element, with a configurable date field name.  Provides useful properties and utility methods for temporal data related operations, such as calculating the associated date range, creating a subset for a given date range, getting an data item by date and getting the nearest data item by date.

* **TimeInterval** 

	Describes an interval of time by count and unit (millisecond, second, minute, hour, day, week, month, quarter, year, etc.).  Provides useful methods for time interval related operations, such iterating a date range against a visitor function and incrementing and decrementing dates.

## Factories ##

* **ClassFactory**

	ClassFactory improves significantly upon the mx.core.ClassFactory:
	* The generator specified can be a Class, String, IFactory, or Object instance.
	* Constructor parameters are supported.
	* Initialization properties (specified as key/value pairs) are assigned to each instance created by the factory.
	* Event listener(s) can be added for specified event types (if the instance created is an IEventDispatcher).

* **DataRendererFactory**

	DataRendererFactory is used to generate IDataRenderer instances for use with Lists, Grids and Populators where the developer needs to customize settings on each renderer instance based on the current value of the corresponding 'data' object. 
	DataRendererFactory introduces the support for runtime data-driven properties, which update in response to to runtime changes of the backing 'data' object.

* **StyleableFactory**

	StyleableFactory extends ClassFactory to add support for initializing generated instances with styles.

	StyleableFactory allows developers to include or mix style settings in <code>properties</code>; this feature reduces the developers burden to remember if a specific component option is a 'style' or a 'property'.

* **StyleableRendererFactory**

	StyleableRendererFactory is used to generate IDataRenderer instances for use with Lists, Grids and Populators where the developer needs to customize settings on each renderer instance based on the current value of the corresponding 'data' object.
	
	StyleableRendererFactory introduces support for runtime data-driven properties and styles, which update in response to runtime changes of the backing 'data' object.

## Text ##

* **Label**

	Extends the standard Flex Label component to add support for additional styles, such as `linkColor`, `linkDecoration`, `hoverLinkColor`, `hoverLinkDecoration`, `activeLinkColor` and `activeLinkDecoration`, which configure the text color and presence of underlines for normal, hover and active states of links specified in HTML text.

* **Text**

	Extends the standard Flex Text component to add support for additional styles, such as `linkColor`, `linkDecoration`, `hoverLinkColor`, `hoverLinkDecoration`, `activeLinkColor` and `activeLinkDecoration` which configuring the text color and presence of underlines for normal, hover and active states of links specified in HTML text.

## Utilities ##

* **ArrayUtil**

	Utility methods related to Arrays, such as `clone()`, `equals()`, `contains()`, `containing()`, `merge()`, `merging()`, `exclude()`, `excluding()`, `difference()`.

* **BitmapDataUtil**

	Utility methods related to BitmapData, such as `grayscale()`, `tint()`, `brightness()` and `transparency()`.

* **ClassUtil**

	Utility methods related to Classes, such as `getClassFor()`, `createInstance()` with variable constructor arguments.

* **CollectionViewUtil**

	Utility methods related to CollectionViewUtil such as `create()` to create an ICollectionView from an Object parameter.

* **ComparatorUtil**

	Utility methods related to deep object instance comparison, returning a collection of Property instances describing the instance properties that differ.

* **DateUtil**

	Utility methods related to Dates, such `compare()`, `duration()`, `min()`, `max()`, `range()`, `floor()`, `ceil()`, etc. and constants for representing time units, days and (localized) months.  Dates can be represented as Date instances, numeric date/time values or Strings.  Supports date field names and deeply nested properties via dot notation.

* **DelayedCall**

	Utility methods for scheduling delayed calls to a specified function with arguments.

* **DictionaryUtil**

	Utility methods related to Dictionary, such as `toArray()`, `createFromObjectProperties()`, `createExistenceIndex()`, `createObjectIndexByKey()`, `createObjectIndexByProperty()`.

* **DisplayObjectContainerUtil**

	Utility methods related to interaction with DisplayObjectContainers (or Containers) including easily obtaining an Array of children and re-ordering children using bringForward(), bringToFront(), sendBackward() and sendToBack().

* **EventDispatcherUtil**

	Utility methods related to EventDispatcher, such as `addEventListeners()`.

* **FactoryPool**

	An object pool that wraps an `IFactory`.

* **FormatUtil**

	Utility methods related to formatting, such as `formatNumberOrdinalSuffix()`.

* **GraphicsUtil**

	Utility methods related to Graphics, such as `drawPolyLine()`.

* **InvalidationTracker**

	Implements support for `[Invalidate("displaylist,properties,size")]` metadata on `[Bindable]` public properties as an alternative to the common pattern of writing verbose boilerplate code to define custom get / set method pairs with a backing variable and changed flags.

* **ImageUtil**

	Utility methods related to Image content, such as `grayscale()`, `tint()`, `brightness()` and `transparency()`.

* **IterableUtil**

	Utility methods related to iterable item sets (Array, ArrayCollection, Proxy, etc.), such as `getItemById()`, `getItemIndexById()`, `getItemByIndex()`, `getItemsByProperty()`, `getFirstItem()`, and `getLastItem()`.  Supports custom id field names and deep property traversal via dot notation.

* **LogicUtil**

	Utility methods related to Boolean expression logic, such as `and()` and `or()`, useful for expressing && in MXML attributes.

* **MetadataUtil**

	Utility methods related to Metadata, such as `getMetadataAttribute()`.

* **NumberUtil**

	Utility methods related to Number, such as `compare()`, `isWholeNumber()`, `sanitizeNumber()`.

* **PropertyUtil**

	Utility methods related to Object properties, such as `applyProperties()`, `getObjectPropertyValue()` and `hasProperty()`.  Supports deeply nested properties via dot notation.

* **RandomUtil**

	Utility methods related to generating random numbers, such as `between()`.

* **RectangleUtil**

	Utility methods related to Rectangle, such as `isValid()`, `normalize()`, `translate()`, and `center()`.

* **RuntimeEvaluationUtil**

	Utility methods related to runtime evaluation of values against an Object instance.

* **SampleSetUtil**

	Utility methods related to SampleSets, such as collating SampleSets of potentially differing sampling intervals into a combined TemporalData instance containing the sample data with the finest granularity.

* **SkinUtil**

	Utility methods related to component skins, such as `create()`, `layout()`, `resize()` and `validate()`.  Supports DisplayObject, IInvalidating, IProgrammaticSkin and ISimpleStyleClient skins.

* **StatisticUtil**

	Utility methods relating to statistics, such as `frequency()`, `mean()`, `range()`, `standardDeviation()`, `sum()`, and `variance()`.  Supports value field names and deeply nested properties via dot notation.

* **StringInflectionUtil**

	Utility methods related to String inflection, such as `n()` which returns either the singular or plural string based on the specified count.

* **StyleUtil**

	Utility methods related to styles, such as `getStyleDeclaration()`, `setStyleDeclaration()` and `applyStyles()`.

* **XMLUtil**

	Utility methods related to XML, such as `initFromXML()`, `toProperties()`, `getAttribute()`, `isAttributeTrue()`, `isBoolean()` and `isTrue()`.

## Resources ##

* [Source](http://github.com/CodeCatalyst/flex-extensions)

* [Issues](http://github.com/CodeCatalyst/flex-extensions/issues)