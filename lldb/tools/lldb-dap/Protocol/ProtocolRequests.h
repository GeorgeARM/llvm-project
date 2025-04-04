//===-- ProtocolTypes.h ---------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains POD structs based on the DAP specification at
// https://microsoft.github.io/debug-adapter-protocol/specification
//
// This is not meant to be a complete implementation, new interfaces are added
// when they're needed.
//
// Each struct has a toJSON and fromJSON function, that converts between
// the struct and a JSON representation. (See JSON.h)
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_TOOLS_LLDB_DAP_PROTOCOL_PROTOCOL_REQUESTS_H
#define LLDB_TOOLS_LLDB_DAP_PROTOCOL_PROTOCOL_REQUESTS_H

#include "Protocol/ProtocolBase.h"
#include "Protocol/ProtocolTypes.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/JSON.h"
#include <cstdint>
#include <optional>
#include <string>

namespace lldb_dap::protocol {

/// Arguments for `disconnect` request.
struct DisconnectArguments {
  /// A value of true indicates that this `disconnect` request is part of a
  /// restart sequence.
  std::optional<bool> restart;

  /// Indicates whether the debuggee should be terminated when the debugger is
  /// disconnected. If unspecified, the debug adapter is free to do whatever it
  /// thinks is best. The attribute is only honored by a debug adapter if the
  /// corresponding capability `supportTerminateDebuggee` is true.
  std::optional<bool> terminateDebuggee;

  /// Indicates whether the debuggee should stay suspended when the debugger is
  /// disconnected. If unspecified, the debuggee should resume execution. The
  /// attribute is only honored by a debug adapter if the corresponding
  /// capability `supportSuspendDebuggee` is true.
  std::optional<bool> suspendDebuggee;
};
bool fromJSON(const llvm::json::Value &, DisconnectArguments &,
              llvm::json::Path);

/// Response to `disconnect` request. This is just an acknowledgement, so no
/// body field is required.
using DisconnectResponse = VoidResponse;

/// Features supported by DAP clients.
enum ClientFeature : unsigned {
  eClientFeatureVariableType,
  eClientFeatureVariablePaging,
  eClientFeatureRunInTerminalRequest,
  eClientFeatureMemoryReferences,
  eClientFeatureProgressReporting,
  eClientFeatureInvalidatedEvent,
  eClientFeatureMemoryEvent,
  /// Client supports the `argsCanBeInterpretedByShell` attribute on the
  /// `runInTerminal` request.
  eClientFeatureArgsCanBeInterpretedByShell,
  eClientFeatureStartDebuggingRequest,
  /// The client will interpret ANSI escape sequences in the display of
  /// `OutputEvent.output` and `Variable.value` fields when
  /// `Capabilities.supportsANSIStyling` is also enabled.
  eClientFeatureANSIStyling,
};

/// Format of paths reported by the debug adapter.
enum PathFormat : unsigned { ePatFormatPath, ePathFormatURI };

/// Arguments for `initialize` request.
struct InitializeRequestArguments {
  /// The ID of the debug adapter.
  std::string adatperID;

  /// The ID of the client using this adapter.
  std::optional<std::string> clientID;

  /// The human-readable name of the client using this adapter.
  std::optional<std::string> clientName;

  /// The ISO-639 locale of the client using this adapter, e.g. en-US or de-CH.
  std::optional<std::string> locale;

  /// Determines in what format paths are specified. The default is `path`,
  /// which is the native format.
  std::optional<PathFormat> pathFormat = ePatFormatPath;

  /// If true all line numbers are 1-based (default).
  std::optional<bool> linesStartAt1;

  /// If true all column numbers are 1-based (default).
  std::optional<bool> columnsStartAt1;

  /// The set of supported features reported by the client.
  llvm::DenseSet<ClientFeature> supportedFeatures;

  /// lldb-dap Extensions
  /// @{

  /// Source init files when initializing lldb::SBDebugger.
  std::optional<bool> lldbExtSourceInitFile;

  /// @}
};
bool fromJSON(const llvm::json::Value &, InitializeRequestArguments &,
              llvm::json::Path);

/// Response to `initialize` request. The capabilities of this debug adapter.
using InitializeResponseBody = std::optional<Capabilities>;

/// Arguments for `source` request.
struct SourceArguments {
  /// Specifies the source content to load. Either `source.path` or
  /// `source.sourceReference` must be specified.
  std::optional<Source> source;

  /// The reference to the source. This is the same as `source.sourceReference`.
  /// This is provided for backward compatibility since old clients do not
  /// understand the `source` attribute.
  int64_t sourceReference;
};
bool fromJSON(const llvm::json::Value &, SourceArguments &, llvm::json::Path);

/// Response to `source` request.
struct SourceResponseBody {
  /// Content of the source reference.
  std::string content;

  /// Content type (MIME type) of the source.
  std::optional<std::string> mimeType;
};
llvm::json::Value toJSON(const SourceResponseBody &);

} // namespace lldb_dap::protocol

#endif
