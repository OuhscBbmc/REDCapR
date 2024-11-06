dag-write
=================

Follow the typical steps to import & establish project, plus

1.  Assign two users to the "api" role, plus:
    1. "unittestphifree": not assigned to a dag
    1. "unittestphifree-dag1": assigned to "dag-a" dag.
1.  Create tokens for each user (and copy to the server's credential file)

1. Make sure the plugin on your test server is updated to the correct `project_id` value in the delete sql.
   The sql is in [wipe-project-redcapr-dag-write.php](../../../../utility/plugins/wipe-project-redcapr-dag-write.php).
