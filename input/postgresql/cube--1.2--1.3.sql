/* contrib/cube/cube--1.2--1.3.sql */  \echo Use "ALTER EXTENSION cube UPDATE TO '1.3'" to load this file. \quit  ALTER OPERATOR <= (cube, cube) SET ( RESTRICT = scalarlesel, JOIN = scalarlejoinsel );
  ALTER OPERATOR >= (cube, cube) SET ( RESTRICT = scalargesel, JOIN = scalargejoinsel );
 