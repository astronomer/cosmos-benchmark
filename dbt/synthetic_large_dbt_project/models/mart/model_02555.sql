{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02167') }},
        {{ ref('model_01963') }},
        {{ ref('model_01807') }}
)
select id, 'model_02555' as name from sources
