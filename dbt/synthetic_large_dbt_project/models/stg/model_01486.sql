{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00091') }},
        {{ ref('model_00021') }}
)
select id, 'model_01486' as name from sources
