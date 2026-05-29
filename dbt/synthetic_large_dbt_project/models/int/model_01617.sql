{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00879') }},
        {{ ref('model_01402') }},
        {{ ref('model_01271') }}
)
select id, 'model_01617' as name from sources
