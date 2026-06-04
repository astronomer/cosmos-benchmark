{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01692') }},
        {{ ref('model_02233') }},
        {{ ref('model_01500') }}
)
select id, 'model_02677' as name from sources
