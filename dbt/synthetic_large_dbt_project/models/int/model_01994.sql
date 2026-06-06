{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01077') }},
        {{ ref('model_00952') }}
)
select id, 'model_01994' as name from sources
