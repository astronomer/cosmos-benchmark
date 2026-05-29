{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00191') }},
        {{ ref('model_00590') }},
        {{ ref('model_00511') }}
)
select id, 'model_01424' as name from sources
