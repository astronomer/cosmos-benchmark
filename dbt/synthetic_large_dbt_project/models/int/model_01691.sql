{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00764') }}
)
select id, 'model_01691' as name from sources
