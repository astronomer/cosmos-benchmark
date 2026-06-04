{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01642') }},
        {{ ref('model_01710') }},
        {{ ref('model_02209') }}
)
select id, 'model_02672' as name from sources
