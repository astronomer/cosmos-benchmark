{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00192') }}
)
select id, 'model_01231' as name from sources
