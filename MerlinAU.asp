<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- Use router-provided CSS -->
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <link rel="shortcut icon" href="images/favicon.png" />
    <link rel="icon" href="images/favicon.png" />
    <link rel="stylesheet" type="text/css" href="index_style.css" />
    <link rel="stylesheet" type="text/css" href="form_style.css" />
    <!-- Other meta tags and links -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Existing scripts -->
    <script type="text/javascript" src="/state.js"></script>
    <script type="text/javascript" src="/general.js"></script>
    <script type="text/javascript" src="/popup.js"></script>
    <script type="text/javascript" src="/help.js"></script>
    <script type="text/javascript" src="/validator.js"></script>
    <script type="text/javascript">
    var custom_settings;
    function LoadCustomSettings(){
	    custom_settings = <% get_custom_settings(); %>;
	    for(var prop in custom_settings) {
		    if(Object.prototype.hasOwnProperty.call(custom_settings, prop)) {
			    if(prop.indexOf('MerlinAU') != -1 && prop.indexOf('MerlinAU_version') == -1){
				    eval('delete custom_settings.'+prop)
			    }
		    }
	    }
    }

    function SetCurrentPage() {
        /* Set the proper return pages */
        document.form.next_page.value = window.location.pathname.substring(1);
        document.form.current_page.value = window.location.pathname.substring(1);
    }

    function initializeFields() {
        console.log("Initializing fields...");
        let fwUpdateEnabled = document.getElementById('fwUpdateEnabled');
        let changelogCheckEnabled = document.getElementById('ChangelogCheckEnabled');
        let routerPassword = document.getElementById('routerPassword');
        let fwUpdatePostponement = document.getElementById('fwUpdatePostponement');
        let emailNotificationsEnabled = document.getElementById('emailNotificationsEnabled');
        let autobackupEnabled = document.getElementById('AutobackupEnabled');
        let secondaryEmail = document.getElementById('secondaryEmail');
        let emailFormat = document.getElementById('emailFormat');
        let rogFWBuildType = document.getElementById('rogFWBuildType');
        // Safe value assignments
        if (custom_settings) {
            if (routerPassword) routerPassword.value = custom_settings.routerPassword || '';
            if (fwUpdatePostponement) fwUpdatePostponement.value = custom_settings.fwUpdatePostponement || '0';
            if (secondaryEmail) secondaryEmail.value = custom_settings.secondaryEmail || '';
            if (emailFormat) emailFormat.value = custom_settings.emailFormatType || 'HTML';
            if (rogFWBuildType) rogFWBuildType.value = custom_settings.rogFWBuildType || 'ROG';
            if (fwUpdateEnabled) fwUpdateEnabled.checked = !!custom_settings.fwUpdateEnabled;
            if (changelogCheckEnabled) changelogCheckEnabled.checked = !!custom_settings.changelogCheckEnabled;
            if (emailNotificationsEnabled) emailNotificationsEnabled.checked = !!custom_settings.emailNotificationsEnabled;
            if (autobackupEnabled) autobackupEnabled.checked = !!custom_settings.autobackupEnabled;
        } else {
            console.error("Custom settings not loaded.");
        }
    }

    function initial() {
        SetCurrentPage();
        LoadCustomSettings();
        show_menu();

        // Debugging iframe behavior
        document.getElementById('hidden_frame').onload = function () {
            console.log("Hidden frame loaded with server response.");
            hideLoading();
        };

        initializeFields();
        initializeCollapsibleSections();
    }

    function SaveActionsConfig() {
        custom_settings.routerPassword = document.getElementById('routerPassword')?.value || '';
        custom_settings.fwUpdatePostponement = document.getElementById('fwUpdatePostponement')?.value || '0';
        custom_settings.fwUpdateEnabled = document.getElementById('fwUpdateEnabled')?.value || '';
        custom_settings.changelogCheckEnabled = document.getElementById('changelogCheckEnabled')?.value || '';

        // Save to hidden input field
        document.getElementById('amng_custom').value = JSON.stringify(custom_settings);

        // Add a timeout fallback
        setTimeout(() => {
            console.warn("Server response timed out.");
            hideLoading();
        }, 10000);

        // Apply the settings
        showLoading();
        document.form.submit();
        console.log("Form submitted.");
    }

    function SaveAdvancedConfig() {
        custom_settings.secondaryEmail = document.getElementById('secondaryEmail')?.value || '';
        custom_settings.emailFormatType = document.getElementById('emailFormat')?.value || 'HTML';
        custom_settings.rogFWBuildType = document.getElementById('rogFWBuildType')?.value || 'ROG';
        custom_settings.emailNotificationsEnabled = document.getElementById('emailNotificationsEnabled')?.value || '';
        custom_settings.autobackupEnabled = document.getElementById('autobackupEnabled')?.value || '';

        // Save to hidden input field
        document.getElementById('amng_custom').value = JSON.stringify(custom_settings);

        // Add a timeout fallback
        setTimeout(() => {
            console.warn("Server response timed out.");
            hideLoading();
        }, 10000);

        // Apply the settings
        showLoading();
        document.form.submit();
        console.log("Form submitted.");
    }


    function initializeCollapsibleSections() {
        if (typeof jQuery !== 'undefined') {
            $('.collapsible-jquery').each(function() {
                // Ensure sections are expanded by default
                $(this).addClass('active');  // Add 'active' class to indicate expanded state
                $(this).next('tbody').show();  // Make sure content is visible

                // Add a cursor pointer for better UX
                $(this).css('cursor', 'pointer');

                // Toggle logic on click
                $(this).on('click', function() {
                    $(this).toggleClass('active');
                    $(this).next('tbody').slideToggle();
                });
            });
        } else {
            console.error("jQuery is not loaded. Collapsible sections will not work.");
        }
    }
    </script>
</head>
<body onload="initial();" class="bg">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

    <form method="post" name="form" action="start_apply.htm" target="hidden_frame">
        <input type="hidden" name="action_script" value="start_merlinau" />
        <input type="hidden" name="current_page" value="" />
        <input type="hidden" name="next_page" value="" />
        <input type="hidden" name="modified" value="0" />
        <input type="hidden" name="action_mode" value="apply" />
        <input type="hidden" name="action_wait" value="90" />
        <input type="hidden" name="first_time" value="" />
        <input type="hidden" name="SystemCmd" value="" />
        <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get('preferred_lang'); %>" />
        <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>" />
        <input type="hidden" name="installedfirm" value="<% nvram_get("innerver"); %>" />
        <input type="hidden" name="amng_custom" id="amng_custom" value="" />

        <table class="content" cellpadding="0" cellspacing="0" style="margin:0 auto;">
            <tr>
                <td width="17">&nbsp;</td>
                <td width="202" valign="top">
                    <div id="mainMenu"></div>
                    <div id="subMenu"></div>
                </td>
                <td valign="top">
                    <div id="tabMenu" class="submenuBlock"></div>

                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
                                <table width="760px" cellpadding="4" cellspacing="0" class="FormTitle" style="height: 1169px;">
                                    <tbody>
                                        <tr style="background-color:#4D595D;">
                                            <td valign="top">
                                                <div>&nbsp;</div>
                                                <div class="formfonttitle" style="text-align:center;">MerlinAU Dashboard v1.3.8</div>
                                                <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                                <div class="formfontdesc">
                                                    This is the MerlinAU Dashboard integrated into the router UI.
                                                </div>
                                                <div style="line-height:10px;">&nbsp;</div>

                                                <!-- Firmware Status Section -->
                                                <table width="100%" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead class="collapsible-jquery" id="firmwareStatusSection">
                                                        <tr>
                                                            <td>Firmware Status (click to expand/collapse)</td>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <table style="margin: 0 auto; text-align: left;">
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>F/W Product/Model ID:</strong></td>
                                                                        <td style="padding: 4px;">GT-AXE11000</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>USB Storage Connected:</strong></td>
                                                                        <td style="padding: 4px;">True</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>F/W Version Installed:</strong></td>
                                                                        <td style="padding: 4px;"><% nvram_get("innerver"); %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>F/W Update Available:</strong></td>
                                                                        <td id="fwVersion" style="padding: 4px;">NONE FOUND</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>F/W Update Estimated Run Date:</strong></td>
                                                                        <td style="padding: 4px;">False</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding: 4px;"><strong>Auto-Backup Enabled:</strong></td>
                                                                        <td style="padding: 4px;">False</td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <div style="line-height:10px;">&nbsp;</div>

                                                <!-- Actions Section -->
                                                <table width="100%" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead class="collapsible-jquery" id="actionsSection">
                                                        <tr>
                                                            <td>Actions (click to expand/collapse)</td>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    <tr>
                                                        <td>
                                                        <div style="text-align: center; margin-top: 10px;">
                                                            <button type="button" onclick="checkFirmwareUpdate()">Run F/W Update Check Now</button>
                                                        </div>
                                                            <form id="actionsForm">
                                                                <table width="100%" border="0" cellpadding="5" cellspacing="5">
                                                                    <tr>
                                                                        <td><label for="fwUpdateEnabled">Enable F/W Update Check</label></td>
                                                                        <td><input type="checkbox" id="fwUpdateEnabled" name="fwUpdateEnabled" /></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><label for="ChangelogCheckEnabled">Enable Changelog Check</label></td>
                                                                        <td><input type="checkbox" id="ChangelogCheckEnabled" name="ChangelogCheckEnabled" /></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><label for="routerPassword">Router Login Password</label></td>
                                                                        <td><input type="password" id="routerPassword" name="routerPassword" /></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><label for="fwUpdatePostponement">F/W Update Postponement (0-60 days)</label></td>
                                                                        <td><input type="number" id="fwUpdatePostponement" name="fwUpdatePostponement" min="0" max="60" /></td>
                                                                    </tr>
                                                                </table>
                                                                <div style="text-align: center; margin-top: 10px;">
                                                                    <input type="submit" onclick="SaveActionsConfig();" value="Save" class="button_gen savebutton" name="button">
                                                                </div>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>

                                                <div style="line-height:10px;">&nbsp;</div>

                                                <!-- Advanced Options Section -->
                                                <table width="100%" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead class="collapsible-jquery" id="advancedOptionsSection">
                                                        <tr>
                                                            <td>Advanced Options (click to expand/collapse)</td>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                            <div style="text-align: center; margin-top: 10px;">
                                                                <button type="button" onclick="Uninstall()">Uninstall Now</button>
                                                            </div>
                                                                <form id="advancedOptionsForm">
                                                                    <table width="100%" border="0" cellpadding="5" cellspacing="5">
                                                                        <tr>
                                                                            <td><label for="emailNotificationsEnabled">Enable F/W Update Email Notifications</label></td>
                                                                            <td><input type="checkbox" id="emailNotificationsEnabled" name="emailNotificationsEnabled" /></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><label for="AutobackupEnabled">Enable Auto-Backups</label></td>
                                                                            <td><input type="checkbox" id="AutobackupEnabled" name="AutobackupEnabled" /></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><label for="secondaryEmail">Secondary Email for Notifications</label></td>
                                                                            <td><input type="email" id="secondaryEmail" name="secondaryEmail" /></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><label for="emailFormat">Email Format</label></td>
                                                                            <td>
                                                                                <select id="emailFormat" name="emailFormat">
                                                                                    <option value="HTML">HTML</option>
                                                                                    <option value="PlainText">Plain Text</option>
                                                                                </select>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><label for="rogFWBuildType">ROG F/W Build Type</label></td>
                                                                            <td>
                                                                                <select id="rogFWBuildType" name="rogFWBuildType">
                                                                                    <option value="ROG">ROG</option>
                                                                                    <option value="Pure">Pure</option>
                                                                                </select>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <div style="text-align: center; margin-top: 10px;">
                                                                        <input type="submit" onclick="SaveAdvancedConfig();" value="Save" class="button_gen savebutton" name="button">
                                                                    </div>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <div style="margin-top:10px;text-align:center;">
                                                    MerlinAU v1.3.8 by ExtremeFiretop &amp; Martinski W.
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="10"></td>
            </tr>
        </table>
    </form>

    <div id="footer"></div>
</body>
</html>
