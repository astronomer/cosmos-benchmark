{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00875') }},
        {{ ref('model_00893') }},
        {{ ref('model_01492') }}
)
select id, 'model_01585' as name from sources
