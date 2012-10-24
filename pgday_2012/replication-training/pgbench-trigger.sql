-- SET demo.threshold TO 1000;

CREATE OR REPLACE FUNCTION public.syncrep_important_delta()
  RETURNS TRIGGER
  LANGUAGE PLpgSQL
AS $$
DECLARE
  threshold integer := current_setting('demo.threshold')::int;
  delta integer := NEW.abalance - OLD.abalance;
BEGIN
  IF delta > threshold
  THEN
	SET LOCAL synchronous_commit TO on;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS syncrep_important_delta ON pgbench_accounts;

CREATE TRIGGER syncrep_important_delta
         AFTER UPDATE
            ON pgbench_accounts
      FOR EACH ROW
       EXECUTE PROCEDURE public.syncrep_important_delta();
