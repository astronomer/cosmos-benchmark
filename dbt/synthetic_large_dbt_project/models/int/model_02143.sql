{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01265') }},
        {{ ref('model_01338') }},
        {{ ref('model_01395') }}
)
select id, 'model_02143' as name from sources
