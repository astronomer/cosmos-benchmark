{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01691') }}
)
select id, 'model_02265' as name from sources
