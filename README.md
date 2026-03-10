# Wiki Mentat

> This README is still a work in progress. Please don't go installing Wiki Mentat on your Discord servers just yet!

A system to help make managing [MediaWiki](https://www.mediawiki.org)-based wiki sites easier by connecting to a Discord 
server. Originally developed as a bespoke Discord Bot for the [Dune: Awakening Community Wiki](https://awakening.wiki), 
this revamped system has been designed to be added to multiple Discord servers and help manage multiple Wiki sites 
simultaneously.

The system is hosted at https://mentat.wiki where users can find the Admin panel and instructions to integrate their 
wikis/discord servers to the main instance. However, this project is open source and as such anyone could run their own 
instance or fork of the project. Further instructions for self-hosting to come.

## Adding the Extension to your Wiki server

Wiki Mentat works by receiving updates from the wiki servers via webhooks. In order to do this, the wiki requires an
Extension be added to the server - [mw-mentat](https://github.com/FlamingMojo/mw-mentat). See that repository for 
installation instructions

*In future there are plans to add a job to poll RecentChanges via a Wiki Bot. This is still being investigated as a 
potential alternative to needing an Extension added as some Wiki farms don't allow ad-hoc extensions.*

## Adding Wiki Mentat to your Discord server

[Add Wiki Mentat to your Discord Server](https://discord.com/oauth2/authorize?client_id=1463966841914261710&scope=bot%20applications.commands&permissions=2416176128)

The Discord Bot requires the following permissions to function.

| Permission                             | Reason                                                                              | Note                                                                                                   |
|----------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| Manage Messages                        | To delete messages the bot sends (e.g. Mission embeds or temporary prompt messages) | Only deletes it's own messages. Never pins messages.                                                   |
| View Channels                          | To allow any channel to be configured in the admin panel                            |                                                                                                        |
| Send Messages                          | To send messages required for the bot to function                                   |                                                                                                        |
| Embed Links                            | To use Embeds required for the bot to function                                      |                                                                                                        |
| Attach Files                           | To attach files to messages where appropriate                                       |                                                                                                        |
| Mention @everyone, @here and All Roles | To send alerts to specific channels where appropriate                               | Only @here is ever called, and only sparingly e.g. with the mission submissions and rewards.           |
| Read Message History                   | To keep track of messages sent to be updated (specifically in the Missions system)  | Technically covers an edge case with bot channel permissions, but a lot breaks without this permission |
| Use Application Commands               | To use application commands for the bot to function                                 |                                                                                                        |
| Manage Roles                           | To grant specific roles to Users when verifying ownership of a Wiki user            | Only required if you want the grant verified role feature                                              |

It requires the `Bot` scope when being added, as some functionality depends on users mentioning the bot. It also requires
the `Application Command` scope as it uses slash commands

## Configuring your Discord Server to integrate with your Wiki server

- TO ADD WHEN THE ADMIN PANEL HAS BEEN UPDATED

### Adding a Wiki Bot to Mentat

In order to get full functionality out of Mentat, it needs a way to interact with the Wiki programmatically. to do this,
a Wiki bot user can be added. See [The Docs](https://www.mediawiki.org/wiki/Manual:Bots). A Wiki bot requires the following
grants to be added to Mentat. Only the guild (Discord Server) that adds the Wiki bot can use it. The password provided to
Mentat via the admin panel is securely encrypted and not accessible by any means outside the discord automations.

| Grant                          | Reason                                        | Note                                                                                               |
|--------------------------------|-----------------------------------------------|----------------------------------------------------------------------------------------------------|
| Basic Rights                   | Basic login access required                   |                                                                                                    |
| High-volume (bot) access       | To be marked as a bot and bypass ratelimits   | It's unlikely Mentat will go near any rate limits but it is incase of high volume discord activity |
| Edit existing pages            | Basic page edit functionality                 |                                                                                                    |
| Edit protected pages           | To edit protected pages                       | Primarily used with the legacy block lists and discord verification. May not be needed in future   |
| Create, edit and move pages    | Basic page edit functionality                 |                                                                                                    |
| Upload new files               | To allow the bot to upload files from Discord |                                                                                                    |
| Upload, replace and move files | To allow the bot to upload files from Discord |                                                                                                    |
| Rollback changes to pages      | Basic page edit functionality                 |                                                                                                    |
| Block and unblock users        | To allow the bot to block abuse from Discord  |                                                                                                    |
| View deleted files and pages   | Basic page edit functionality                 |                                                                                                    |
| View restricted log entries    | To allow the bot to block abuse from Discord  |                                                                                                    |
| Protect and unprotect pages    | To edit protected pages                       | Primarily used with the legacy block lists and discord verification. May not be needed in future   |

