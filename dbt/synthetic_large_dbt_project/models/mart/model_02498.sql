{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02011') }},
        {{ ref('model_01592') }}
)
select id, 'model_02498' as name from sources
