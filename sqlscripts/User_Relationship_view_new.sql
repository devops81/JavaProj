CREATE OR REPLACE FORCE VIEW USER_RELATIONSHIP_VIEW_NEW (USERID, TERRITORY_ID, TERRITORY, REGION_ID, REGION, TA_ID, TA, NAME, MSL_START, REGIONUSER_ID, REGIONUSER, TERRITORYSTARTDATE, REGIONSTARTDATE)
                AS
  SELECT u.id   AS userId,
    o.id        AS territory_id,
    o.optvalue  AS territory,
    o1.id       AS region_id,
    o1.optvalue AS region,
    o2.id       AS TA_ID,
    o2.optvalue AS TA,
    u.lastname
    ||', '
    ||u.firstname name,
    u.msl_start_date msl_start,
    u2.id AS regionuser_id,
    u2.lastname
    ||', '
    ||u2.firstname RegionUser,
    u.msl_start_date territoryStartDate,
    u2.msl_start_date regionStartDate
  FROM user_table u,
    user_relationship ur,
    user_relationship ur1,
    user_table u2,
    option_lookup o,
    option_lookup o1,
    option_lookup o2
  WHERE ur.user_id          = u.id
  AND ur1.user_id           = u2.id
  AND o.id                  = ur.territory
  AND o1.id                 = ur1.territory
  AND o1.id                 = o.parent
  AND o2.id                 = o1.parent
  AND ur.relationship_type  = 1
  AND ur1.relationship_type = 2
  AND ur.begin_date        <= sysdate
  AND ur.end_date          >= sysdate
  AND ur1.begin_date       <= sysdate
  AND ur1.end_date         >= sysdate
  AND u.deleteflag != 'Y';