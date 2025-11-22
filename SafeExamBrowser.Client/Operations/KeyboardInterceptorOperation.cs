/*
 * Copyright (c) 2025 ETH Zürich, IT Services
 * 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

using SafeExamBrowser.Core.Contracts.OperationModel;
using SafeExamBrowser.Core.Contracts.OperationModel.Events;
using SafeExamBrowser.I18n.Contracts;
using SafeExamBrowser.Logging.Contracts;
using SafeExamBrowser.Monitoring.Contracts.Keyboard;

namespace SafeExamBrowser.Client.Operations
{
	internal class KeyboardInterceptorOperation : ClientOperation
	{
		private readonly IKeyboardInterceptor keyboardInterceptor;
		private readonly ILogger logger;

		public override event StatusChangedEventHandler StatusChanged;

		public KeyboardInterceptorOperation(ClientContext context, IKeyboardInterceptor keyboardInterceptor, ILogger logger) : base(context)
		{
			this.keyboardInterceptor = keyboardInterceptor;
			this.logger = logger;
		}

		public override OperationResult Perform()
		{
#if RELAXED_MODE
			logger.Info("Skipping keyboard interception in relaxed mode.");
			StatusChanged?.Invoke(TextKey.OperationStatus_StartKeyboardInterception);
			return OperationResult.Success;
#else
			logger.Info("Starting keyboard interception...");
			StatusChanged?.Invoke(TextKey.OperationStatus_StartKeyboardInterception);

			keyboardInterceptor.Start();

			return OperationResult.Success;
#endif
		}

		public override OperationResult Revert()
		{
#if RELAXED_MODE
			logger.Info("Skipping keyboard interception stop in relaxed mode.");
			StatusChanged?.Invoke(TextKey.OperationStatus_StopKeyboardInterception);
			return OperationResult.Success;
#else
			logger.Info("Stopping keyboard interception...");
			StatusChanged?.Invoke(TextKey.OperationStatus_StopKeyboardInterception);

			keyboardInterceptor.Stop();

			return OperationResult.Success;
#endif
		}
	}
}
