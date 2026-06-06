{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00737') }}
)
select id, 'model_01279' as name from sources
