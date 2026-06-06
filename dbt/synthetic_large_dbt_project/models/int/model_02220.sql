{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00933') }},
        {{ ref('model_00903') }}
)
select id, 'model_02220' as name from sources
