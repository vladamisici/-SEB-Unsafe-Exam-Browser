/*
 * Copyright (c) 2025 ETH Zürich, IT Services
 * 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

namespace SafeExamBrowser.Browser.Events
{
	/// <summary>
	/// Indicates that the user requested to switch to a specific tab by index.
	/// </summary>
	internal delegate void TabIndexRequestedEventHandler(int tabIndex);
}
