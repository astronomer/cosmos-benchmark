{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00275') }},
        {{ ref('model_00187') }},
        {{ ref('model_00699') }}
)
select id, 'model_01028' as name from sources
