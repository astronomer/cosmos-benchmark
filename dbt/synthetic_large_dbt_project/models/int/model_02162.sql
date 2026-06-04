{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01343') }},
        {{ ref('model_01270') }},
        {{ ref('model_01186') }}
)
select id, 'model_02162' as name from sources
