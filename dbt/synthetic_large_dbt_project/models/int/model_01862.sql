{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01020') }},
        {{ ref('model_01489') }},
        {{ ref('model_00886') }}
)
select id, 'model_01862' as name from sources
