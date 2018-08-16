/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.net.Uri;
import android.service.carrier.CarrierIdentifier;

import java.util.List;


/**
 * Interface used to interact with the phone.  Mostly this is used by the
 * TelephonyManager class.  A few places are still using this directly.
 * Please clean them up if possible and use TelephonyManager instead.
 *
 * {@hide}
 */
interface ITelephony {

    /**
     * Dial a number. This doesn't place the call. It displays
     * the Dialer screen.
     * @param number the number to be dialed. If null, this
     * would display the Dialer screen with no number pre-filled.
     */
    void dial(String number);

    /**
     * Place a call to the specified number.
     * @param callingPackage The package making the call.
     * @param number the number to be called.
     */
    void call(String callingPackage, String number);

    /**
     * End call if there is a call in progress, otherwise does nothing.
     *
     * @return whether it hung up
     */
    boolean endCall();

    /**
     * End call on particular subId or go to the Home screen
     * @param subId user preferred subId.
     * @return whether it hung up
     */
    boolean endCallForSubscriber(int subId);

    /**
     * Answer the currently-ringing call.
     *
     * If there's already a current active call, that call will be
     * automatically put on hold.  If both lines are currently in use, the
     * current active call will be ended.
     *
     * TODO: provide a flag to let the caller specify what policy to use
     * if both lines are in use.  (The current behavior is hardwired to
     * "answer incoming, end ongoing", which is how the CALL button
     * is specced to behave.)
     *
     * TODO: this should be a oneway call (especially since it's called
     * directly from the key queue thread).
     */
    void answerRingingCall();

    /**
     * Answer the currently-ringing call on particular subId .
     *
     * If there's already a current active call, that call will be
     * automatically put on hold.  If both lines are currently in use, the
     * current active call will be ended.
     *
     * TODO: provide a flag to let the caller specify what policy to use
     * if both lines are in use.  (The current behavior is hardwired to
     * "answer incoming, end ongoing", which is how the CALL button
     * is specced to behave.)
     *
     * TODO: this should be a oneway call (especially since it's called
     * directly from the key queue thread).
     */
    void answerRingingCallForSubscriber(int subId);

    /**
     * Silence the ringer if an incoming call is currently ringing.
     * (If vibrating, stop the vibrator also.)
     *
     * It's safe to call this if the ringer has already been silenced, or
     * even if there's no incoming call.  (If so, this method will do nothing.)
     *
     * TODO: this should be a oneway call too (see above).
     *       (Actually *all* the methods here that return void can
     *       probably be oneway.)
     */
    void silenceRinger();

    /**
     * Check if we are in either an active or holding call
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is OFFHOOK.
     */
    boolean isOffhook(String callingPackage);

    /**
     * Check if a particular subId has an active or holding call
     *
     * @param subId user preferred subId.
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is OFFHOOK.
     */
    boolean isOffhookForSubscriber(int subId, String callingPackage);

    /**
     * Check if an incoming phone call is ringing or call waiting
     * on a particular subId.
     *
     * @param subId user preferred subId.
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is RINGING.
     */
    boolean isRingingForSubscriber(int subId, String callingPackage);

    /**
     * Check if an incoming phone call is ringing or call waiting.
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is RINGING.
     */
    boolean isRinging(String callingPackage);

    /**
     * Check if the phone is idle.
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is IDLE.
     */
    boolean isIdle(String callingPackage);

    /**
     * Check if the phone is idle on a particular subId.
     *
     * @param subId user preferred subId.
     * @param callingPackage the name of the package making the call.
     * @return true if the phone state is IDLE.
     */
    boolean isIdleForSubscriber(int subId, String callingPackage);

    /**
     * Check to see if the radio is on or not.
     * @param callingPackage the name of the package making the call.
     * @return returns true if the radio is on.
     */
    boolean isRadioOn(String callingPackage);

    /**
     * Check to see if the radio is on or not on particular subId.
     * @param subId user preferred subId.
     * @param callingPackage the name of the package making the call.
     * @return returns true if the radio is on.
     */
    boolean isRadioOnForSubscriber(int subId, String callingPackage);

    /**
     * Supply a pin to unlock the SIM.  Blocks until a result is determined.
     * @param pin The pin to check.
     * @return whether the operation was a success.
     */
    boolean supplyPin(String pin);

    /**
     * Supply a pin to unlock the SIM for particular subId.
     * Blocks until a result is determined.
     * @param pin The pin to check.
     * @param subId user preferred subId.
     * @return whether the operation was a success.
     */
    boolean supplyPinForSubscriber(int subId, String pin);

    /**
     * Supply puk to unlock the SIM and set SIM pin to new pin.
     *  Blocks until a result is determined.
     * @param puk The puk to check.
     *        pin The new pin to be set in SIM
     * @return whether the operation was a success.
     */
    boolean supplyPuk(String puk, String pin);

    /**
     * Supply puk to unlock the SIM and set SIM pin to new pin.
     *  Blocks until a result is determined.
     * @param puk The puk to check.
     *        pin The new pin to be set in SIM
     * @param subId user preferred subId.
     * @return whether the operation was a success.
     */
    boolean supplyPukForSubscriber(int subId, String puk, String pin);

    /**
     * Supply a pin to unlock the SIM.  Blocks until a result is determined.
     * Returns a specific success/error code.
     * @param pin The pin to check.
     * @return retValue[0] = Phone.PIN_RESULT_SUCCESS on success. Otherwise error code
     *         retValue[1] = number of attempts remaining if known otherwise -1
     */
    int[] supplyPinReportResult(String pin);

    /**
     * Supply a pin to unlock the SIM.  Blocks until a result is determined.
     * Returns a specific success/error code.
     * @param pin The pin to check.
     * @return retValue[0] = Phone.PIN_RESULT_SUCCESS on success. Otherwise error code
     *         retValue[1] = number of attempts remaining if known otherwise -1
     */
    int[] supplyPinReportResultForSubscriber(int subId, String pin);

    /**
     * Supply puk to unlock the SIM and set SIM pin to new pin.
     * Blocks until a result is determined.
     * Returns a specific success/error code
     * @param puk The puk to check
     *        pin The pin to check.
     * @return retValue[0] = Phone.PIN_RESULT_SUCCESS on success. Otherwise error code
     *         retValue[1] = number of attempts remaining if known otherwise -1
     */
    int[] supplyPukReportResult(String puk, String pin);

    /**
     * Supply puk to unlock the SIM and set SIM pin to new pin.
     * Blocks until a result is determined.
     * Returns a specific success/error code
     * @param puk The puk to check
     *        pin The pin to check.
     * @return retValue[0] = Phone.PIN_RESULT_SUCCESS on success. Otherwise error code
     *         retValue[1] = number of attempts remaining if known otherwise -1
     */
    int[] supplyPukReportResultForSubscriber(int subId, String puk, String pin);

    /**
     * Handles PIN MMI commands (PIN/PIN2/PUK/PUK2), which are initiated
     * without SEND (so <code>dial</code> is not appropriate).
     *
     * @param dialString the MMI command to be executed.
     * @return true if MMI command is executed.
     */
    boolean handlePinMmi(String dialString);


    /**
     * Handles USSD commands.
     *
     * @param subId The subscription to use.
     * @param ussdRequest the USSD command to be executed.
     * @param wrappedCallback receives a callback result.
     */
    void handleUssdRequest(int subId, String ussdRequest, in ResultReceiver wrappedCallback);

    /**
     * Handles PIN MMI commands (PIN/PIN2/PUK/PUK2), which are initiated
     * without SEND (so <code>dial</code> is not appropriate) for
     * a particular subId.
     * @param dialString the MMI command to be executed.
     * @param subId user preferred subId.
     * @return true if MMI command is executed.
     */
    boolean handlePinMmiForSubscriber(int subId, String dialString);

    /**
     * Toggles the radio on or off.
     */
    void toggleRadioOnOff();

    /**
     * Toggles the radio on or off on particular subId.
     * @param subId user preferred subId.
     */
    void toggleRadioOnOffForSubscriber(int subId);

    /**
     * Set the radio to on or off
     */
    boolean setRadio(boolean turnOn);

    /**
     * Set the radio to on or off on particular subId.
     * @param subId user preferred subId.
     */
    boolean setRadioForSubscriber(int subId, boolean turnOn);

    /**
     * Set the radio to on or off unconditionally
     */
    boolean setRadioPower(boolean turnOn);

    /**
     * Request to update location information in service state
     */
    void updateServiceLocation();

    /**
     * Request to update location information for a subscrition in service state
     * @param subId user preferred subId.
     */
    void updateServiceLocationForSubscriber(int subId);

    /**
     * Enable location update notifications.
     */
    void enableLocationUpdates();

    /**
     * Enable location update notifications.
     * @param subId user preferred subId.
     */
    void enableLocationUpdatesForSubscriber(int subId);

    /**
     * Disable location update notifications.
     */
    void disableLocationUpdates();

    /**
     * Disable location update notifications.
     * @param subId user preferred subId.
     */
    void disableLocationUpdatesForSubscriber(int subId);

    /**
     * Allow mobile data connections.
     */
    boolean enableDataConnectivity();

    /**
     * Disallow mobile data connections.
     */
    boolean disableDataConnectivity();

    /**
     * Report whether data connectivity is possible.
     */
    boolean isDataConnectivityPossible();

    Bundle getCellLocation(String callingPkg);

    /**
     * Returns the neighboring cell information of the device.
     */
    List<NeighboringCellInfo> getNeighboringCellInfo(String callingPkg);

     int getCallState();

    /**
     * Returns the call state for a slot.
     */
     int getCallStateForSlot(int slotIndex);

     int getDataActivity();
     int getDataState();

    /**
     * Returns the current active phone type as integer.
     * Returns TelephonyManager.PHONE_TYPE_CDMA if RILConstants.CDMA_PHONE
     * and TelephonyManager.PHONE_TYPE_GSM if RILConstants.GSM_PHONE
     */
    int getActivePhoneType();

    /**
     * Returns the current active phone type as integer for particular slot.
     * Returns TelephonyManager.PHONE_TYPE_CDMA if RILConstants.CDMA_PHONE
     * and TelephonyManager.PHONE_TYPE_GSM if RILConstants.GSM_PHONE
     * @param slotIndex - slot to query.
     */
    int getActivePhoneTypeForSlot(int slotIndex);

    /**
     * Returns the CDMA ERI icon index to display
     * @param callingPackage package making the call.
     */
    int getCdmaEriIconIndex(String callingPackage);

    /**
     * Returns the CDMA ERI icon index to display on particular subId.
     * @param subId user preferred subId.
     * @param callingPackage package making the call.
     */
    int getCdmaEriIconIndexForSubscriber(int subId, String callingPackage);

    /**
     * Returns the CDMA ERI icon mode,
     * 0 - ON
     * 1 - FLASHING
     * @param callingPackage package making the call.
     */
    int getCdmaEriIconMode(String callingPackage);

    /**
     * Returns the CDMA ERI icon mode on particular subId,
     * 0 - ON
     * 1 - FLASHING
     * @param subId user preferred subId.
     * @param callingPackage package making the call.
     */
    int getCdmaEriIconModeForSubscriber(int subId, String callingPackage);

    /**
     * Returns the CDMA ERI text,
     * @param callingPackage package making the call.
     */
    String getCdmaEriText(String callingPackage);

    /**
     * Returns the CDMA ERI text for particular subId,
     * @param subId user preferred subId.
     * @param callingPackage package making the call.
     */
    String getCdmaEriTextForSubscriber(int subId, String callingPackage);

    /**
     * Returns true if OTA service provisioning needs to run.
     * Only relevant on some technologies, others will always
     * return false.
     */
    boolean needsOtaServiceProvisioning();

    /**
     * Sets the voicemail number for a particular subscriber.
     */
    boolean setVoiceMailNumber(int subId, String alphaTag, String number);

     /**
      * Sets the voice activation state for a particular subscriber.
      */
    void setVoiceActivationState(int subId, int activationState);

     /**
      * Sets the data activation state for a particular subscriber.
      */
    void setDataActivationState(int subId, int activationState);

     /**
      * Returns the voice activation state for a particular subscriber.
      * @param subId user preferred sub
      * @param callingPackage package queries voice activation state
      */
    int getVoiceActivationState(int subId, String callingPackage);

     /**
      * Returns the data activation state for a particular subscriber.
      * @param subId user preferred sub
      * @param callingPackage package queris data activation state
      */
    int getDataActivationState(int subId, String callingPackage);

    /**
      * Returns the unread count of voicemails
      */
    int getVoiceMessageCount();

    /**
     * Returns the unread count of voicemails for a subId.
     * @param subId user preferred subId.
     * Returns the unread count of voicemails
     */
    int getVoiceMessageCountForSubscriber(int subId);

    /**
      * Returns true if current state supports both voice and data
      * simultaneously. This can change based on location or network condition.
      */
    boolean isConcurrentVoiceAndDataAllowed(int subId);

    Bundle getVisualVoicemailSettings(String callingPackage, int subId);

    String getVisualVoicemailPackageName(String callingPackage, int subId);

    oneway void disableVisualVoicemailSmsFilter(String callingPackage, int subId);

    /**
     * Send a visual voicemail SMS. Internal use only.
     * Requires caller to be the default dialer and have SEND_SMS permission
     */
    void sendVisualVoicemailSmsForSubscriber(in String callingPackage, in int subId,
            in String number, in int port, in String text, in PendingIntent sentIntent);

    // Send the special dialer code. The IPC caller must be the current default dialer.
    void sendDialerSpecialCode(String callingPackageName, String inputCode);

    /**
     * Returns the network type for data transmission
     * Legacy call, permission-free
     */
    int getNetworkType();

    /**
     * Returns the network type of a subId.
     * @param subId user preferred subId.
     * @param callingPackage package making the call.
     */
    int getNetworkTypeForSubscriber(int subId, String callingPackage);

    /**
     * Returns the network type for data transmission
     * @param callingPackage package making the call.
     */
    int getDataNetworkType(String callingPackage);

    /**
     * Returns the data network type of a subId
     * @param subId user preferred subId.
     * @param callingPackage package making the call.
     */
    int getDataNetworkTypeForSubscriber(int subId, String callingPackage);

    /**
      * Returns the voice network type of a subId
      * @param subId user preferred subId.
      * @param callingPackage package making the call.
      * Returns the network type
      */
    int getVoiceNetworkTypeForSubscriber(int subId, String callingPackage);

    /**
     * Return true if an ICC card is present
     */
    boolean hasIccCard();

    /**
     * Return true if an ICC card is present for a subId.
     * @param slotIndex user preferred slotIndex.
     * Return true if an ICC card is present
     */
    boolean hasIccCardUsingSlotIndex(int slotIndex);

    /**
     * Return if the current radio is LTE on CDMA. This
     * is a tri-state return value as for a period of time
     * the mode may be unknown.
     *
     * @param callingPackage the name of the calling package
     * @return {@link Phone#LTE_ON_CDMA_UNKNOWN}, {@link Phone#LTE_ON_CDMA_FALSE}
     * or {@link PHone#LTE_ON_CDMA_TRUE}
     */
    int getLteOnCdmaMode(String callingPackage);

    /**
     * Return if the current radio is LTE on CDMA. This
     * is a tri-state return value as for a period of time
     * the mode may be unknown.
     *
     * @param callingPackage the name of the calling package
     * @return {@link Phone#LTE_ON_CDMA_UNKNOWN}, {@link Phone#LTE_ON_CDMA_FALSE}
     * or {@link PHone#LTE_ON_CDMA_TRUE}
     */
    int getLteOnCdmaModeForSubscriber(int subId, String callingPackage);

    /**
     * Returns the all observed cell information of the device.
     */
    List<CellInfo> getAllCellInfo(String callingPkg);

    /**
     * Sets minimum time in milli-seconds between onCellInfoChanged
     */
    void setCellInfoListRate(int rateInMillis);

    /**
     * get default sim
     * @return sim id
     */
    int getDefaultSim();

    /**
     * Opens a logical channel to the ICC card.
     *
     * Input parameters equivalent to TS 27.007 AT+CCHO command.
     *
     * @param subId The subscription to use.
     * @param AID Application id. See ETSI 102.221 and 101.220.
     * @param p2 P2 parameter (described in ISO 7816-4).
     * @return an IccOpenLogicalChannelResponse object.
     */
    IccOpenLogicalChannelResponse iccOpenLogicalChannel(int subId, String AID, int p2);

    /**
     * Closes a previously opened logical channel to the ICC card.
     *
     * Input parameters equivalent to TS 27.007 AT+CCHC command.
     *
     * @param subId The subscription to use.
     * @param channel is the channel id to be closed as retruned by a
     *            successful iccOpenLogicalChannel.
     * @return true if the channel was closed successfully.
     */
    boolean iccCloseLogicalChannel(int subId, int channel);

    /**
     * Transmit an APDU to the ICC card over a logical channel.
     *
     * Input parameters equivalent to TS 27.007 AT+CGLA command.
     *
     * @param subId The subscription to use.
     * @param channel is the channel id to be closed as retruned by a
     *            successful iccOpenLogicalChannel.
     * @param cla Class of the APDU command.
     * @param instruction Instruction of the APDU command.
     * @param p1 P1 value of the APDU command.
     * @param p2 P2 value of the APDU command.
     * @param p3 P3 value of the APDU command. If p3 is negative a 4 byte APDU
     *            is sent to the SIM.
     * @param data Data to be sent with the APDU.
     * @return The APDU response from the ICC card with the status appended at
     *            the end.
     */
    String iccTransmitApduLogicalChannel(int subId, int channel, int cla, int instruction,
            int p1, int p2, int p3, String data);

    /**
     * Transmit an APDU to the ICC card over the basic channel.
     *
     * Input parameters equivalent to TS 27.007 AT+CSIM command.
     *
     * @param subId The subscription to use.
     * @param cla Class of the APDU command.
     * @param instruction Instruction of the APDU command.
     * @param p1 P1 value of the APDU command.
     * @param p2 P2 value of the APDU command.
     * @param p3 P3 value of the APDU command. If p3 is negative a 4 byte APDU
     *            is sent to the SIM.
     * @param data Data to be sent with the APDU.
     * @return The APDU response from the ICC card with the status appended at
     *            the end.
     */
    String iccTransmitApduBasicChannel(int subId, int cla, int instruction,
            int p1, int p2, int p3, String data);

    /**
     * Returns the response APDU for a command APDU sent through SIM_IO.
     *
     * @param subId The subscription to use.
     * @param fileID
     * @param command
     * @param p1 P1 value of the APDU command.
     * @param p2 P2 value of the APDU command.
     * @param p3 P3 value of the APDU command.
     * @param filePath
     * @return The APDU response.
     */
    byte[] iccExchangeSimIO(int subId, int fileID, int command, int p1, int p2, int p3,
            String filePath);

    /**
     * Send ENVELOPE to the SIM and returns the response.
     *
     * @param subId The subscription to use.
     * @param contents  String containing SAT/USAT response in hexadecimal
     *                  format starting with command tag. See TS 102 223 for
     *                  details.
     * @return The APDU response from the ICC card, with the last 4 bytes
     *         being the status word. If the command fails, returns an empty
     *         string.
     */
    String sendEnvelopeWithStatus(int subId, String content);

    /**
     * Read one of the NV items defined in {@link RadioNVItems} / {@code ril_nv_items.h}.
     * Used for device configuration by some CDMA operators.
     *
     * @param itemID the ID of the item to read.
     * @return the NV item as a String, or null on any failure.
     */
    String nvReadItem(int itemID);

    /**
     * Set the preferred network type.
     * Used for device configuration by some CDMA operators.
     *
     * @param subId the id of the subscription to update.
     * @param networkType the preferred network type, defined in RILConstants.java.
     * @return true on success; false on any failure.
     */
    boolean setPreferredNetworkType(int subId, int networkType);

    /**
     * User enable/disable Mobile Data.
     *
     * @param enable true to turn on, else false
     */
    void setDataEnabled(int subId, boolean enable);

    /**
     * Get the user enabled state of Mobile Data.
     *
     * @return true on enabled
     */
    boolean getDataEnabled(int subId);

    /**
     * Get P-CSCF address from PCO after data connection is established or modified.
     * @param apnType the apnType, "ims" for IMS APN, "emergency" for EMERGENCY APN
     * @param callingPackage The package making the call.
     */
    String[] getPcscfAddress(String apnType, String callingPackage);

    /**
     * Set IMS registration state
     */
    void setImsRegistrationState(boolean registered);

    /**
     * Return MDN string for CDMA phone.
     * @param subId user preferred subId.
     */
    String getCdmaMdn(int subId);

    /**
     * Return MIN string for CDMA phone.
     * @param subId user preferred subId.
     */
    String getCdmaMin(int subId);

    /**
     * Has the calling application been granted special privileges by the carrier.
     *
     * If any of the packages in the calling UID has carrier privileges, the
     * call will return true. This access is granted by the owner of the UICC
     * card and does not depend on the registered carrier.
     *
     * TODO: Add a link to documentation.
     *
     * @param subId The subscription to use.
     * @return carrier privilege status defined in TelephonyManager.
     */
    int getCarrierPrivilegeStatus(int subId);

    /**
     * Similar to above, but check for the package whose name is pkgName.
     */
    int checkCarrierPrivilegesForPackage(String pkgName);

    /**
     * Similar to above, but check across all phones.
     */
    int checkCarrierPrivilegesForPackageAnyPhone(String pkgName);

    /**
     * Returns list of the package names of the carrier apps that should handle the input intent
     * and have carrier privileges for the given phoneId.
     *
     * @param intent Intent that will be sent.
     * @param phoneId The phoneId on which the carrier app has carrier privileges.
     * @return list of carrier app package names that can handle the intent on phoneId.
     *         Returns null if there is an error and an empty list if there
     *         are no matching packages.
     */
    List<String> getCarrierPackageNamesForIntentAndPhone(in Intent intent, int phoneId);

    /**
     * Set the line 1 phone number string and its alphatag for the current ICCID
     * for display purpose only, for example, displayed in Phone Status. It won't
     * change the actual MSISDN/MDN. To unset alphatag or number, pass in a null
     * value.
     *
     * @param subId the subscriber that the alphatag and dialing number belongs to.
     * @param alphaTag alpha-tagging of the dailing nubmer
     * @param number The dialing number
     * @return true if the operation was executed correctly.
     */
    boolean setLine1NumberForDisplayForSubscriber(int subId, String alphaTag, String number);

    /**
     * Returns the displayed dialing number string if it was set previously via
     * {@link #setLine1NumberForDisplay}. Otherwise returns null.
     *
     * @param subId whose dialing number for line 1 is returned.
     * @param callingPackage The package making the call.
     * @return the displayed dialing number if set, or null if not set.
     */
    String getLine1NumberForDisplay(int subId, String callingPackage);

    /**
     * Returns the displayed alphatag of the dialing number if it was set
     * previously via {@link #setLine1NumberForDisplay}. Otherwise returns null.
     *
     * @param subId whose alphatag associated with line 1 is returned.
     * @param callingPackage The package making the call.
     * @return the displayed alphatag of the dialing number if set, or null if
     *         not set.
     */
    String getLine1AlphaTagForDisplay(int subId, String callingPackage);

    String[] getMergedSubscriberIds(String callingPackage);

    /**
     * Override the operator branding for the current ICCID.
     *
     * Once set, whenever the SIM is present in the device, the service
     * provider name (SPN) and the operator name will both be replaced by the
     * brand value input. To unset the value, the same function should be
     * called with a null brand value.
     *
     * <p>Requires Permission:
     *   {@link android.Manifest.permission#MODIFY_PHONE_STATE MODIFY_PHONE_STATE}
     *  or has to be carrier app - see #hasCarrierPrivileges.
     *
     * @param subId The subscription to use.
     * @param brand The brand name to display/set.
     * @return true if the operation was executed correctly.
     */
    boolean setOperatorBrandOverride(int subId, String brand);

    /**
     * Returns a list of packages that have carrier privileges.
     */
    List<String> getPackagesWithCarrierPrivileges();

    /**
     * Return the application ID for the app type.
     *
     * @param subId the subscription ID that this request applies to.
     * @param appType the uicc app type,
     * @return Application ID for specificied app type or null if no uicc or error.
     */
    String getAidForAppType(int subId, int appType);

    /**
    * Return the Electronic Serial Number.
    *
    * Requires that the calling app has READ_PRIVILEGED_PHONE_STATE permission
    *
    * @param subId the subscription ID that this request applies to.
    * @return ESN or null if error.
    * @hide
    */
    String getEsn(int subId);

    /**
    * Return the Preferred Roaming List Version
    *
    * Requires that the calling app has READ_PRIVILEGED_PHONE_STATE permission
    * @param subId the subscription ID that this request applies to.
    * @return PRLVersion or null if error.
    * @hide
    */
    String getCdmaPrlVersion(int subId);

    /**
     * Set the allowed carrier list for slotIndex
     * Require system privileges. In the future we may add this to carrier APIs.
     *
     * @return The number of carriers set successfully. Should match length of
     * carriers on success.
     */
    int setAllowedCarriers(int slotIndex, in List<CarrierIdentifier> carriers);

    /**
     * Get the allowed carrier list for slotIndex.
     * Require system privileges. In the future we may add this to carrier APIs.
     *
     * @return List of {@link android.service.carrier.CarrierIdentifier}; empty list
     * means all carriers are allowed.
     */
    List<CarrierIdentifier> getAllowedCarriers(int slotIndex);

    /**
     * Action set from carrier signalling broadcast receivers to enable/disable metered apns
     * Permissions android.Manifest.permission.MODIFY_PHONE_STATE is required
     * @param subId the subscription ID that this action applies to.
     * @param enabled control enable or disable metered apns.
     * @hide
     */
    void carrierActionSetMeteredApnsEnabled(int subId, boolean visible);

    /**
     * Action set from carrier signalling broadcast receivers to enable/disable radio
     * Permissions android.Manifest.permission.MODIFY_PHONE_STATE is required
     * @param subId the subscription ID that this action applies to.
     * @param enabled control enable or disable radio.
     * @hide
     */
    void carrierActionSetRadioEnabled(int subId, boolean enabled);

    /**
     * Get aggregated video call data usage since boot.
     * Permissions android.Manifest.permission.READ_NETWORK_USAGE_HISTORY is required.
     * @return total data usage in bytes
     * @hide
     */
    long getVtDataUsage();

    /**
     * Policy control of data connection. Usually used when data limit is passed.
     * @param enabled True if enabling the data, otherwise disabling.
     * @param subId Subscription index
     * @hide
     */
    void setPolicyDataEnabled(boolean enabled, int subId);

    /**
     * Set SIM card power state. Request is equivalent to inserting or removing the card.
     * @param slotIndex SIM slot id
     * @param powerUp True if powering up the SIM, otherwise powering down
     * @hide
     * */
    void setSimPowerStateForSlot(int slotIndex, boolean powerUp);

    /**
     * Returns a list of Forbidden PLMNs from the specified SIM App
     * Returns null if the query fails.
     *
     *
     * <p>Requires that the calling app has READ_PRIVILEGED_PHONE_STATE
     *
     * @param subId subscription ID used for authentication
     * @param appType the icc application type, like {@link #APPTYPE_USIM}
     */
    String[] getForbiddenPlmns(int subId, int appType);

    /**
     * Check if phone is in emergency callback mode
     * @return true if phone is in emergency callback mode
     * @param subId the subscription ID that this action applies to.
     * @hide
     */
    boolean getEmergencyCallbackMode(int subId);
}