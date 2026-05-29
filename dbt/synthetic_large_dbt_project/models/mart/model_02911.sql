{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02241') }},
        {{ ref('model_01709') }},
        {{ ref('model_01875') }}
)
select id, 'model_02911' as name from sources
