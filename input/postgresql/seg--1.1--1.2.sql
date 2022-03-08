/* contrib/seg/seg--1.1--1.2.sql */  \echo Use "ALTER EXTENSION seg UPDATE TO '1.2'" to load this file. \quit  ALTER OPERATOR <= (seg, seg) SET ( RESTRICT = scalarlesel, JOIN = scalarlejoinsel );
  ALTER OPERATOR >= (seg, seg) SET ( RESTRICT = scalargesel, JOIN = scalargejoinsel );
 