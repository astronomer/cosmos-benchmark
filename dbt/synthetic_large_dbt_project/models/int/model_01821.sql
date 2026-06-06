{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01277') }},
        {{ ref('model_00786') }},
        {{ ref('model_01224') }}
)
select id, 'model_01821' as name from sources
