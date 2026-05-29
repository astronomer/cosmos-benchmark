{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01660') }},
        {{ ref('model_01696') }}
)
select id, 'model_02368' as name from sources
